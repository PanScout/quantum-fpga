#!/usr/bin/env python3
"""Parse QPU simulation results and plot quantum time evolution."""

import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

RESULTS_FILE = Path(__file__).resolve().parent.parent / "build" / "qpu_results.txt"
OUTPUT_PNG = Path(__file__).resolve().parent / "qpu_results.png"

# Fixed-point format: sfixed(14 downto -21) → 36 bits, fractional bits = 21
FRAC_BITS = 21
TOTAL_BITS = 36

N_TIMESTEPS = 30
DIM = 2  # vector dimension (2^numQubits for 1 qubit)


def hex_to_sfixed36(hex_str: str) -> float:
    """Convert a 9-char hex string (36 bits) to a float via sfixed(14,-21)."""
    val = int(hex_str, 16)
    # Sign extend: if MSB is set, subtract 2^36
    if val >= (1 << (TOTAL_BITS - 1)):
        val -= 1 << TOTAL_BITS
    return val / (1 << FRAC_BITS)


def load_results(path: Path) -> np.ndarray:
    """Load qpu_results.txt → complex array of shape (N_TIMESTEPS, DIM)."""
    lines = path.read_text().strip().splitlines()
    assert len(lines) == N_TIMESTEPS * DIM, (
        f"Expected {N_TIMESTEPS * DIM} lines, got {len(lines)}"
    )

    psi = np.zeros((N_TIMESTEPS, DIM), dtype=complex)
    for idx, line in enumerate(lines):
        line = line.strip()
        assert len(line) == 18, f"Line {idx}: expected 18 hex chars, got {len(line)}"
        re_hex = line[:9]   # upper 36 bits → real
        im_hex = line[9:]   # lower 36 bits → imag
        re = hex_to_sfixed36(re_hex)
        im = hex_to_sfixed36(im_hex)
        # Column-major order: word index = DIM * t + row
        t, row = divmod(idx, DIM)
        psi[t, row] = complex(re, im)

    return psi


def main():
    psi = load_results(RESULTS_FILE)
    t_steps = np.arange(N_TIMESTEPS)

    prob0 = np.abs(psi[:, 0]) ** 2
    prob1 = np.abs(psi[:, 1]) ** 2

    # Analytical: Pauli-X Hamiltonian H=[[0,1],[1,0]], initial state |0⟩
    # exp(-iHt)|0⟩ = cos(t)|0⟩ - i sin(t)|1⟩
    # The QPU uses dt=1 per step, so t = step index
    t_analytical = np.linspace(0, N_TIMESTEPS - 1, 300)
    cos2 = np.cos(t_analytical) ** 2
    sin2 = np.sin(t_analytical) ** 2

    fig, axes = plt.subplots(2, 1, figsize=(10, 8), sharex=True)

    # --- Top panel: occupation probabilities ---
    ax = axes[0]
    ax.plot(t_steps, prob0, "o-", label=r"$|\psi_0|^2$ (FPGA)", markersize=4)
    ax.plot(t_steps, prob1, "s-", label=r"$|\psi_1|^2$ (FPGA)", markersize=4)
    ax.plot(t_analytical, cos2, "--", color="tab:blue", alpha=0.5, label=r"$\cos^2(t)$")
    ax.plot(t_analytical, sin2, "--", color="tab:orange", alpha=0.5, label=r"$\sin^2(t)$")
    ax.set_ylabel("Probability")
    ax.set_title("QPU Quantum Time Evolution — Pauli-X on |0⟩")
    ax.legend(loc="upper right")
    ax.set_ylim(-0.05, 1.15)
    ax.grid(True, alpha=0.3)

    # --- Bottom panel: real and imaginary parts ---
    ax = axes[1]
    ax.plot(t_steps, psi[:, 0].real, "o-", label=r"Re($\psi_0$)", markersize=4)
    ax.plot(t_steps, psi[:, 0].imag, "v-", label=r"Im($\psi_0$)", markersize=4)
    ax.plot(t_steps, psi[:, 1].real, "s-", label=r"Re($\psi_1$)", markersize=4)
    ax.plot(t_steps, psi[:, 1].imag, "^-", label=r"Im($\psi_1$)", markersize=4)
    ax.set_xlabel("Time step")
    ax.set_ylabel("Amplitude")
    ax.legend(loc="upper right")
    ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig(OUTPUT_PNG, dpi=150)
    print(f"Plot saved to {OUTPUT_PNG}")


if __name__ == "__main__":
    main()
