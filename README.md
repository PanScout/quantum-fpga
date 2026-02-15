# Quantum FPGA

FPGA-based quantum time evolution emulator. Takes a Hamiltonian matrix and an initial state vector over SPI, computes the unitary time evolution operator via Padé approximation of the matrix exponential, and outputs 30 time-stepped state vectors.

Senior design project built for the Intel Arria 10 GX FPGA at the University of Miami College of Engineering.

## Architecture

```
          SPI RX (matrix)      SPI RX (vector)
               │                     │
        ┌──────┴──────┐      ┌───────┴───────┐
        │  assemble   │      │   assemble    │
        │   matrix    │      │    vector     │
        └──────┬──────┘      └───────┬───────┘
               │    matrix_done      │  vector_done
               └────────┬───────────┘
                        │ start_evolution
               ┌────────┴────────┐
               │  quantum_time   │   30 time steps (t = 0 → π)
               │   evolution     │   Each step:
               │                 │     1. Padé approx: U(t) = exp(-iHt)
               │                 │     2. ψ(t) = U(t) · ψ₀
               └────────┬────────┘
                        │
               ┌────────┴────────┐
               │ assemble_psi    │   Collects 30 output vectors
               │    matrix       │
               └────────┬────────┘
                        │
               ┌────────┴────────┐
               │ disassemble_psi │
               │    matrix       │
               └────────┬────────┘
                        │
                    SPI TX (MISO)
```

### QPU Port Interface

| Signal | Dir | Description |
|---|---|---|
| `clk` | in | 100 MHz system clock |
| `reset` | in | Active-high synchronous reset |
| `enable` | in | `1` = receive mode, `0` = transmit mode |
| `SCLK` | in | Shared SPI clock |
| `rx_matrix_SS` / `rx_matrix_MOSI` | in | Matrix SPI (active-low SS) |
| `rx_vector_SS` / `rx_vector_MOSI` | in | Vector SPI (active-low SS) |
| `tx_SS` | in | Transmit SPI chip select |
| `MISO` | out | Transmit data output |
| `psi_matrix_assemble_done` | out | High when all 30 time steps complete |

### Data Format

- **Fixed-point**: `sfixed(14 downto -21)` — 36 bits (15 integer, 21 fractional)
- **Complex number**: 72 bits — `[real(35:0) | imag(35:0)]`, MSB first over SPI
- **Matrix order**: Row-major. For a 2x2: `H(0,0), H(0,1), H(1,0), H(1,1)`
- **Vector order**: Sequential: `psi(0), psi(1)`
- **Output**: 30 time steps x dimension elements = 60 words for 1-qubit

### Pade Approximation Pipeline

Computes `exp(-iHt)` using a [3,3] Pade approximant with scaling and squaring:

1. Form `B = -iHt`
2. Compute infinity-norm of B and scaling factor `S = 2^ceil(log2(norm(B)))`
3. Scale down: `B_s = B / S`
4. Numerator: `P = -(((B_s + 12)B_s + 60)B_s + 120)` (Horner's method)
5. Denominator: `Q = (((B_s - 12)B_s + 60)B_s - 120)` (Horner's method)
6. Matrix inversion: `Q^-1` (Newton-Schulz iteration)
7. `U_s = P * Q^-1`
8. Scale up: `U = U_s^S` (repeated squaring)

## Project Structure

```
src/
├── rtl/              # Synthesizable VHDL
│   ├── qtypes.vhd            # Type definitions (sfixed36, csfixed36, cmatrix, cvector)
│   ├── fixed_pkg.vhd         # Fixed-point arithmetic package
│   ├── qpu.vhd               # Top-level QPU entity
│   ├── quantum_time_evolution.vhd   # 30-step evolution loop
│   ├── quantum_fpga.vhd      # Single-step worker (Pade + matrix-vector multiply)
│   ├── pade_top_level.vhd    # Pade approximation chain
│   ├── spi_receive.vhd       # SPI slave receiver (72-bit words)
│   ├── spi_transmit.vhd      # SPI slave transmitter
│   ├── assemble_matrix.vhd   # Serial -> cmatrix
│   ├── assemble_vector.vhd   # Serial -> cvector
│   ├── disassemble_psi_matrix.vhd  # psi_matrix -> serial
│   └── ...                    # Matrix ops, registers, utilities
└── tb/               # Testbenches and simulation scripts
    ├── qpu_tb.vhd            # GHDL testbench (SPI master stimulus)
    ├── qpu.do                 # ModelSim DO script
    └── ...
python/
└── jupyter/          # Theory notebooks (Pade analysis, visualization)
Makefile              # GHDL build and simulation
```

## Simulation with GHDL

### Prerequisites

- [GHDL](https://github.com/ghdl/ghdl) (tested with 5.1.1, llvm backend)
- [Surfer](https://surfer-project.org/) for waveform viewing (optional)

### Quick Start

```bash
make sim          # Analyze, elaborate, and simulate -> qpu_tb.vcd
make view         # Open VCD in Surfer
make clean        # Remove build artifacts
```

### What the Testbench Does

1. Resets the QPU
2. Sends a **Pauli-X Hamiltonian** `H = [[0,1],[1,0]]` over the matrix SPI
3. Sends initial state **psi_0 = [1, 0]** over the vector SPI
4. Waits for the 30-step quantum time evolution to complete (~226 us sim time)
5. Reads back all 60 result vectors over SPI TX (~1.1 ms sim time)
6. Dumps all signals to `qpu_tb.vcd`

The expected physics: the state oscillates as `psi(t) = [cos(t), -i*sin(t)]` for t from 0 to pi.

## Configuration

The number of qubits is set in `src/rtl/qtypes.vhd`:

```vhdl
constant numQubits : integer := 1;  -- 2^1 = 2-dimensional system
```

Changing this scales the matrix dimension, SPI word count, and computation time accordingly.

## Authors

Kelan Zielinski, Michael Denis, Jasem Alkhashti — University of Miami
