# Quantum_FPGA Simulation DO File
# This script compiles the design files and sets:
#   - Hamiltonian H to the 4x4 identity matrix,
#   - Time input t to 0 + j0.5,
#   - Psi to [1 0 0 0].

# Create the work library
#vlib work

# Compile the qTypes package and the top-level design
#vcom -2008 qTypes.vhd
#vcom -2008 Quantum_FPGA.vhd

# Launch the simulator on the top-level entity
vsim work.Quantum_FPGA

# ---------------------------
# Force the Hamiltonian (H)
# ---------------------------
# Row 0
force -freeze sim:/Quantum_FPGA/H(0)(0).re 1.0
force -freeze sim:/Quantum_FPGA/H(0)(0).im 0.0
force -freeze sim:/Quantum_FPGA/H(0)(1).re 0.0
force -freeze sim:/Quantum_FPGA/H(0)(1).im 0.0
force -freeze sim:/Quantum_FPGA/H(0)(2).re 0.0
force -freeze sim:/Quantum_FPGA/H(0)(2).im 0.0
force -freeze sim:/Quantum_FPGA/H(0)(3).re 0.0
force -freeze sim:/Quantum_FPGA/H(0)(3).im 0.0

# Row 1
force -freeze sim:/Quantum_FPGA/H(1)(0).re 0.0
force -freeze sim:/Quantum_FPGA/H(1)(0).im 0.0
force -freeze sim:/Quantum_FPGA/H(1)(1).re 1.0
force -freeze sim:/Quantum_FPGA/H(1)(1).im 0.0
force -freeze sim:/Quantum_FPGA/H(1)(2).re 0.0
force -freeze sim:/Quantum_FPGA/H(1)(2).im 0.0
force -freeze sim:/Quantum_FPGA/H(1)(3).re 0.0
force -freeze sim:/Quantum_FPGA/H(1)(3).im 0.0

# Row 2
force -freeze sim:/Quantum_FPGA/H(2)(0).re 0.0
force -freeze sim:/Quantum_FPGA/H(2)(0).im 0.0
force -freeze sim:/Quantum_FPGA/H(2)(1).re 0.0
force -freeze sim:/Quantum_FPGA/H(2)(1).im 0.0
force -freeze sim:/Quantum_FPGA/H(2)(2).re 1.0
force -freeze sim:/Quantum_FPGA/H(2)(2).im 0.0
force -freeze sim:/Quantum_FPGA/H(2)(3).re 0.0
force -freeze sim:/Quantum_FPGA/H(2)(3).im 0.0

# Row 3
force -freeze sim:/Quantum_FPGA/H(3)(0).re 0.0
force -freeze sim:/Quantum_FPGA/H(3)(0).im 0.0
force -freeze sim:/Quantum_FPGA/H(3)(1).re 0.0
force -freeze sim:/Quantum_FPGA/H(3)(1).im 0.0
force -freeze sim:/Quantum_FPGA/H(3)(2).re 0.0
force -freeze sim:/Quantum_FPGA/H(3)(2).im 0.0
force -freeze sim:/Quantum_FPGA/H(3)(3).re 1.0
force -freeze sim:/Quantum_FPGA/H(3)(3).im 0.0

# ---------------------------
# Force the Time input (t)
# ---------------------------
# t is a complex fixed-point with fields 're' and 'im'
force -freeze sim:/Quantum_FPGA/t.re 0.0
force -freeze sim:/Quantum_FPGA/t.im 0.5

# ---------------------------
# Force the Psi vector (?)
# ---------------------------
# psi(0) should be 1 + j0; psi(1), psi(2), psi(3) should be 0 + j0.
force -freeze sim:/Quantum_FPGA/psi(0).re 1.0
force -freeze sim:/Quantum_FPGA/psi(0).im 0.0
force -freeze sim:/Quantum_FPGA/psi(1).re 0.0
force -freeze sim:/Quantum_FPGA/psi(1).im 0.0
force -freeze sim:/Quantum_FPGA/psi(2).re 0.0
force -freeze sim:/Quantum_FPGA/psi(2).im 0.0
force -freeze sim:/Quantum_FPGA/psi(3).re 0.0
force -freeze sim:/Quantum_FPGA/psi(3).im 0.0

# Run the simulation for 1000 ns (adjust as needed)
#run 1000 ns
