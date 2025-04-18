#------------------------------------------------------------------------------
# run_quantum_time_evolution.tcl
#
# TCL simulation script for the Quantum_Time_Evolution component.
#
# This script:
#  - Loads the Quantum_Time_Evolution design.
#  - Forces the clock with the specified pattern.
#      Clock: high (1) for 2 ps, then low (0) for 2 ps (repeat period = 4 ps).
#  - Applies a synchronous reset.
#  - Forces psiAssemblerDone and matrixAssemblerDone high.
#  - Loads H_in with an identity matrix (for a 2x2 cmatrix) and psi_in as an
#    identity vector (for a 2-element cvector) using 36-bit hex values.
#  - Forces start_evolution high once both assembler-done signals are high.
#  - Adds waveform signals for the top-level signals as well as internal signals
#    from the quantum_unit/pade_inst instance.
#  - Runs the simulation for 1 us (adjustable) so the full 30-step evolution can
#    be observed.
#  - Leaves the simulation running for interactive inspection.
#
# Adjust hierarchical paths as required by your design.
#------------------------------------------------------------------------------

# Load the design (adjust library and top-level entity name if needed)
vsim -t 1ps work.Quantum_Time_Evolution

# Force the clock with the specified pattern:
#   - '1' for 2 ps, then '0' for 2 ps, repeating every 4 ps.
force -freeze sim:/quantum_time_evolution/clk 1 0, 0 {2 ps} -r 4

#------------------------------------------------------------
# Add top-level waveform signals
#------------------------------------------------------------
add wave -position insertpoint  \
    sim:/quantum_time_evolution/clk \
    sim:/quantum_time_evolution/reset \
    sim:/quantum_time_evolution/psiAssemblerDone \
    sim:/quantum_time_evolution/matrixAssemblerDone \
    sim:/quantum_time_evolution/start_evolution \
    sim:/quantum_time_evolution/H_in \
    sim:/quantum_time_evolution/psi_in \
    sim:/quantum_time_evolution/output_state \
    sim:/quantum_time_evolution/output_valid \
    sim:/quantum_time_evolution/current_t_index \
    sim:/quantum_time_evolution/evolution_complete \
    sim:/quantum_time_evolution/current_state \
    sim:/quantum_time_evolution/next_state \
    sim:/quantum_time_evolution/t_index_reg \
    sim:/quantum_time_evolution/t_index_out_reg \
    sim:/quantum_time_evolution/qfpga_t \
    sim:/quantum_time_evolution/qfpga_done \
    sim:/quantum_time_evolution/qfpga_output \
    sim:/quantum_time_evolution/qfpga_reset \
    sim:/quantum_time_evolution/output_state_reg \
    sim:/quantum_time_evolution/output_valid_reg \
    sim:/quantum_time_evolution/evolution_complete_reg \
    sim:/quantum_time_evolution/NUM_TIME_STEPS \
    sim:/quantum_time_evolution/T_VALUES

#------------------------------------------------------------
# Add internal signals from the pade instance (first set)
#------------------------------------------------------------
add wave -position insertpoint  \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/H \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/t \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/padeDone \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/output

#------------------------------------------------------------
# Add additional internal signals from the pade instance
#------------------------------------------------------------
add wave -position insertpoint  \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/IHTtoNormAndCompareandD1 \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/TorF \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/InfNormOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/IHTtoScalar \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/IHTdirect \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/ScalingFactorOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/ScaleDownOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/Mux2Out \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/PNumeratorOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/PDenominatorOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/InvOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/MatrixMultOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/MatriPowIn \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/Mux4In \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/ScaleUpOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/done \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/matrixInvDone \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/regStdLogicOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/tBuffStart \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/PNumDone \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/PDenDone \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/Mux4Out \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/reg1Out \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/reg2Out \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/tBuffOut \
    sim:/quantum_time_evolution/quantum_unit/pade_inst/Hamiltonian

#------------------------------------------------------------
# Reset phase: Assert reset for 20 ns then deassert it.
#------------------------------------------------------------
force -freeze sim:/quantum_time_evolution/reset 1
run 20 ns
force -freeze sim:/quantum_time_evolution/reset 0
run 10 ns

#------------------------------------------------------------
# Force the assembler-done signals high.
#------------------------------------------------------------
force -freeze sim:/quantum_time_evolution/psiAssemblerDone 1
force -freeze sim:/quantum_time_evolution/matrixAssemblerDone 1

#------------------------------------------------------------
# Load H_in with an identity matrix.
#
# For a 2x2 cmatrix (dimension = 2):
#
# H_in(0)(0): (1.0, 0.0)
# H_in(0)(1): (0.0, 0.0)
# H_in(1)(0): (0.0, 0.0)
# H_in(1)(1): (1.0, 0.0)
#
# Using 36-bit hex values:
#  1.0 => X"002000000"
#  0.0 => X"000000000"
#------------------------------------------------------------
force -freeze sim:/quantum_time_evolution/H_in(0)(0).re "X\"002000000\""
force -freeze sim:/quantum_time_evolution/H_in(0)(0).im "X\"000000000\""
force -freeze sim:/quantum_time_evolution/H_in(0)(1).re "X\"000000000\""
force -freeze sim:/quantum_time_evolution/H_in(0)(1).im "X\"000000000\""
force -freeze sim:/quantum_time_evolution/H_in(1)(0).re "X\"000000000\""
force -freeze sim:/quantum_time_evolution/H_in(1)(0).im "X\"000000000\""
force -freeze sim:/quantum_time_evolution/H_in(1)(1).re "X\"002000000\""
force -freeze sim:/quantum_time_evolution/H_in(1)(1).im "X\"000000000\""

#------------------------------------------------------------
# Load psi_in with an identity vector.
#
# For a cvector of length 2:
# psi_in(0): (1.0, 0.0) => X"002000000"
# psi_in(1): (0.0, 0.0) => X"000000000"
#------------------------------------------------------------
force -freeze sim:/quantum_time_evolution/psi_in(0).re "X\"002000000\""
force -freeze sim:/quantum_time_evolution/psi_in(0).im "X\"000000000\""
force -freeze sim:/quantum_time_evolution/psi_in(1).re "X\"000000000\""
force -freeze sim:/quantum_time_evolution/psi_in(1).im "X\"000000000\""

#------------------------------------------------------------
# Drive start_evolution high.
#
# With both assembler-done signals at '1', the state machine will
# assert start_evolution into RUN_CALCULATION.
#------------------------------------------------------------
force -freeze sim:/quantum_time_evolution/start_evolution 1

#------------------------------------------------------------
# Run the simulation.
#
# Run for enough time (e.g., 1 us) to cover the full 30-step evolution.
#------------------------------------------------------------
run 1 ns

# The simulation will continue running so you may inspect the waveforms.
