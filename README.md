# Quantum FPGA

FPGA-based quantum time evolution emulator. Takes a Hamiltonian matrix and an initial state vector over SPI, computes the unitary time evolution operator via Pade approximation of the matrix exponential, and outputs 30 time-stepped state vectors.

Senior design project built for the Intel Arria 10 GX FPGA at the University of Miami College of Engineering.

## Architecture

```
          SPI RX (matrix)      SPI RX (vector)
               |                     |
        +------+------+      +-------+-------+
        |  assemble   |      |   assemble    |
        |   matrix    |      |    vector     |
        +------+------+      +-------+-------+
               |    matrix_done      |  vector_done
               +--------+-----------+
                        | start_evolution
               +--------+--------+
               |  quantum_time   |   30 time steps (t = 0 -> pi)
               |   evolution     |   Each step:
               |                 |     1. Pade approx: U(t) = exp(-iHt)
               |                 |     2. psi(t) = U(t) * psi_0
               +--------+--------+
                        |
               +--------+--------+
               | assemble_psi    |   Collects 30 output vectors
               |    matrix       |
               +--------+--------+
                        |
               +--------+--------+
               | disassemble_psi |
               |    matrix       |
               +--------+--------+
                        |
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

- **Fixed-point**: `sfixed(14 downto -21)` -- 36 bits (15 integer, 21 fractional)
- **Complex number**: 72 bits -- `[real(35:0) | imag(35:0)]`, MSB first over SPI
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
6. Matrix inversion: `Q^-1` (Newton-Schulz iteration, 40 iterations)
7. `U_s = P * Q^-1`
8. Scale up: `U = U_s^(2^S)` (repeated squaring)

## Project Structure

```
src/
├── rtl/
│   ├── pkg/              # Type definitions and fixed-point arithmetic
│   │   ├── fixed_float_types.vhd
│   │   ├── fixed_pkg.vhd
│   │   └── qtypes.vhd           # sfixed36, csfixed36, cmatrix, cvector, psi_matrix
│   ├── math/             # Matrix and vector arithmetic
│   │   ├── matrix_by_matrix_multiplication.vhd
│   │   ├── matrix_by_vector_multiplication.vhd
│   │   ├── matrix_by_scalar_multiplication.vhd
│   │   ├── matrix_addition.vhd
│   │   ├── matrix_transpose.vhd
│   │   ├── add_scalar_to_diagonal.vhd
│   │   ├── multiply_column_by_scalar.vhd
│   │   ├── multiply_by_scalar_then_add.vhd
│   │   ├── add_vectors_element_wise.vhd
│   │   ├── absolute_row_summation.vhd     # Row-wise L1 norm (for infinity norm)
│   │   ├── max_real_part_of_cvector.vhd   # Max of real parts in a vector
│   │   ├── calculate_norm_and_compare.vhd # Infinity norm with threshold compare
│   │   ├── generate_scaling_factor.vhd    # Norm-dependent scaling exponent
│   │   ├── norm_theta_ratio.vhd
│   │   └── ceiling_of_log2.vhd
│   ├── pade/             # Pade approximation pipeline
│   │   ├── pade_top_level.vhd             # Orchestrator: scale, approximate, unscale
│   │   ├── pade_numerator.vhd             # Horner's method for numerator polynomial
│   │   ├── pade_denominator.vhd           # Horner's method for denominator polynomial
│   │   ├── insert_imaginary_time_into_cmatrix.vhd  # Computes B = -iHt
│   │   ├── scale_cmatrix_down.vhd         # Right-shift matrix by S bits
│   │   └── repeated_matrix_squaring.vhd   # Computes M^(2^S) via iterated squaring
│   ├── inversion/        # Newton-Schulz matrix inversion
│   │   ├── matrix_inversion.vhd           # Top-level: guess + iterative refinement
│   │   ├── matrix_inversion_state_machine.vhd  # X_{n+1} = X_n(2I - AX_n), 40 iters
│   │   ├── matrix_inversion_initial_guess.vhd  # Scaled transpose approximation
│   │   └── linear_reciprocal_approximation.vhd # Linear regression for 1/x
│   ├── spi/              # SPI interface and data serialization
│   │   ├── spi_receive.vhd               # SPI slave receiver (72-bit words)
│   │   ├── spi_transmit.vhd              # SPI slave transmitter
│   │   ├── assemble_matrix.vhd           # SPI words -> cmatrix
│   │   ├── assemble_vector.vhd           # SPI words -> cvector
│   │   ├── assemble_psi_matrix.vhd       # cvectors -> psi_matrix (30 columns)
│   │   ├── disassemble_matrix.vhd        # cmatrix -> SPI words
│   │   └── disassemble_psi_matrix.vhd    # psi_matrix -> SPI words
│   ├── util/             # Registers, buffers, and misc
│   │   ├── register_cfixed.vhd
│   │   ├── register_cmatrix.vhd
│   │   ├── register_cvector.vhd
│   │   ├── register_std_logic.vhd
│   │   ├── tri_state_buffer_cmatrix.vhd
│   │   ├── tri_state_buffer_cvector.vhd
│   │   ├── delayed_pulse_generator.vhd   # 50-cycle startup delay
│   │   ├── clock_divider.vhd
│   │   └── hex_to_7seg.vhd
│   └── top/              # System-level entities
│       ├── qpu.vhd                       # Top-level QPU (SPI + evolution + output)
│       ├── quantum_time_evolution.vhd    # 30-step evolution loop
│       └── quantum_fpga.vhd             # Single-step: Pade approx + mat-vec multiply
└── tb/                   # Testbenches and simulation scripts
    ├── qpu_tb.vhd                        # GHDL testbench (SPI master stimulus)
    └── *.do                              # ModelSim DO scripts

python/
├── plot_results.py       # Parse QPU hex output and plot time evolution
└── jupyter/              # Theory notebooks (Pade analysis, visualization)

build/                    # GHDL build artifacts (generated)
Makefile                  # GHDL build, simulation, and plotting
```

## Simulation with GHDL

### Prerequisites

- [GHDL](https://github.com/ghdl/ghdl) (tested with 5.1.1, llvm backend)
- [Surfer](https://surfer-project.org/) for waveform viewing (optional)
- Python 3 with numpy and matplotlib (for plotting)

### Quick Start

```bash
make sim          # Analyze, elaborate, and simulate -> build/qpu_tb.vcd
make plot         # Run sim + plot results to python/qpu_results.png
make view         # Open VCD in Surfer
make clean        # Remove build artifacts
```

### What the Testbench Does

1. Resets the QPU
2. Sends a **Pauli-X Hamiltonian** `H = [[0,1],[1,0]]` over the matrix SPI
3. Sends initial state **psi_0 = [1, 0]** over the vector SPI
4. Waits for the 30-step quantum time evolution to complete (~226 us sim time)
5. Reads back all 60 result vectors over SPI TX (~1.1 ms sim time)
6. Writes results to `build/qpu_results.txt` (60 lines, 18-char hex per word)
7. Dumps all signals to `build/qpu_tb.vcd`

The expected physics: the state oscillates as `psi(t) = [cos(t), i*sin(t)]` completing one full Rabi cycle over 30 time steps (dt = 2*pi/29). The FPGA achieves ~12 bits of effective precision (~2.7e-4 max error) with norm conservation within ~5e-4.

## Configuration

The number of qubits is set in `src/rtl/pkg/qtypes.vhd`:

```vhdl
constant numQubits : integer := 1;  -- 2^1 = 2-dimensional system
```

Changing this scales the matrix dimension, SPI word count, and computation time accordingly.

## Authors

Kelan Zielinski, Michael Denis, Jasem Alkhashti -- University of Miami
