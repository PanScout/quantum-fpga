#==============================================================================
# ModelSim DO Script for QPU Simulation (Simulating QPU as Top Level)
#
# Assumes:
# - All VHDL files are in the current directory or paths are updated.
# - QPU is the top-level entity to be simulated directly.
# - 'fixed_pkg.vhd' provides the necessary fixed-point package.
#   (Compile 'fixed_pkg_c.vhd' first if it exists).
#==============================================================================


# Clean up old work library
if {[file exists work]} {
  vdel -all
}
vlib work

#==============================================================================
# Compile VHDL Files
#==============================================================================
# IMPORTANT: Update file names and paths as necessary!
# Compile packages first

# Compile fixed-point package (compile fixed_pkg_c.vhd first if applicable)
# vcom path/to/fixed_pkg_c.vhd
vcom fixed_pkg.vhd
vcom qTypes.vhd

# Compile individual component entities (Order might matter if using direct instantiation without component declarations)
# --- Compile leaf components first ---
vcom Absolute_Row_Summation.vhd
vcom Add_Vectors_Element_Wise.vhd
vcom assemble_matrix.vhd
vcom assemble_psi_matrix.vhd
vcom assemble_vector.vhd
vcom Ceiling_Of_Log2.vhd
vcom hex_to_7seg.vhd # Assuming not directly used by QPU, but compiling anyway
vcom Matrix_Addition.vhd
vcom Matrix_By_Scalar_Multiplication.vhd
vcom Matrix_Plus_Scalar.vhd
vcom Matrix_Transpose.vhd
vcom Max_Of_CVector.vhd
vcom Multiply_Column_By_Scalar.vhd # Use the Gauss version if desired
vcom Norm_Theta_Ratio.vhd
vcom ReciprocalEstimation.vhd
vcom Register_cfixed.vhd
vcom Register_cmatrix.vhd
vcom Register_cvector.vhd
vcom Register_std_logic.vhd
vcom Scale_cmatrix_Down.vhd
vcom spi_receive.vhd
vcom spi_transmit.vhd
vcom TristateBuffer_cmatrix.vhd
vcom TristateBuffer_cvector.vhd
vcom TriStateBuffer_std_logic.vhd # Delay component

# --- Compile components with dependencies ---
vcom Calculate_Norm_And_Compare.vhd     # Depends on Absolute_Row_Summation, Max_Of_CVector
vcom disassemble_matrix.vhd          # Depends on Register_* ? (No, likely self-contained FSM)
vcom disassemble_psi_matrix.vhd       # Depends on Register_* ? (No, likely self-contained FSM)
vcom Generate_Scaling_Factor.vhd      # Depends on Norm_Theta_Ratio, Ceiling_Of_Log2
vcom Insert_Imaginary_Time_Into_CMatrix.vhd # Depends on Matrix_By_Scalar_Multiplication
vcom Matrix_By_Vector_Multiplication.vhd # Depends on Multiply_By_Scalar_Then_Add
vcom Multiply_By_Scalar_Then_Add.vhd  # Depends on Multiply_Column_By_Scalar, Add_Vectors_Element_Wise
vcom Matrix_By_Matrix_Multiplication.vhd # Depends on Matrix_By_Vector_Multiplication
vcom Newtons_Guess.vhd                # Depends on Matrix_Transpose, Calculate_Norm_And_Compare, ReciprocalEstimation
vcom Matrix_Inversion_State_Machine.vhd # Depends on Matrix_By_Matrix_Multiplication
vcom Matrix_Inversion.vhd             # Depends on Newtons_Guess, Matrix_Inversion_State_Machine
vcom padeDenominator.vhd              # Depends on Matrix_Plus_Scalar, Matrix_By_Matrix_Multiplication
vcom padeNumerator.vhd                # Depends on Matrix_Plus_Scalar, Matrix_By_Matrix_Multiplication
vcom Scale_cmatrix_Up.vhd             # Depends on Matrix_By_Matrix_Multiplication
vcom Pade_Top_Level.vhd               # Depends on many components
vcom Quantum_FPGA.vhd                 # Depends on Pade_Top_Level, Matrix_By_Vector_Multiplication
vcom Quantum_Time_Evolution.vhd       # Depends on Quantum_FPGA

# Compile the top-level QPU entity
vcom QPU.vhd

#==============================================================================
# Start Simulation
#==============================================================================
# Simulate the QPU entity directly
# Use -novopt for easier debugging if required
# Use -t 1ps for finer time resolution if needed
vsim work.qpu

#==============================================================================
# Add Waveforms
#==============================================================================
# Add the signals provided by the user, adjusted for QPU as top level
# The '/qpu_tb' prefix is removed
add wave -position insertpoint  \
sim:/qpu/clk \
sim:/qpu/reset \
sim:/qpu/enable \
sim:/qpu/rx_matrix_SCLK \
sim:/qpu/rx_matrix_SS \
sim:/qpu/rx_matrix_MOSI \
sim:/qpu/rx_matrix_NUM \
sim:/qpu/rx_matrix_spi_valid \
sim:/qpu/rx_vector_SCLK \
sim:/qpu/rx_vector_SS \
sim:/qpu/rx_vector_MOSI \
sim:/qpu/rx_vector_NUM \
sim:/qpu/rx_vector_spi_valid \
sim:/qpu/tx_SCLK \
sim:/qpu/tx_SS \
sim:/qpu/MISO \
sim:/qpu/tx_spi_valid \
sim:/qpu/psi_matrix_assemble_done \
sim:/qpu/receive_mode_active \
sim:/qpu/transmit_mode_active \
sim:/qpu/spi_matrix_data \
sim:/qpu/internal_matrix_valid \
sim:/qpu/spi_vector_data \
sim:/qpu/internal_vector_valid \
sim:/qpu/assembled_matrix \
sim:/qpu/matrix_done \
sim:/qpu/assembled_vector \
sim:/qpu/vector_done \
sim:/qpu/start_evolution \
sim:/qpu/qte_output_state \
sim:/qpu/qte_output_valid \
sim:/qpu/qte_t_index \
sim:/qpu/qte_evolution_complete \
sim:/qpu/assembled_psi_matrix \
sim:/qpu/internal_psi_asm_done \
sim:/qpu/start_disassembly \
sim:/qpu/disassembled_data \
sim:/qpu/disassemble_valid_out \
sim:/qpu/disassemble_done \
sim:/qpu/internal_tx_spi_valid

#==============================================================================
# Define Procedures for SPI Transactions (Optional but recommended)
#==============================================================================

# Procedure to send one 72-bit word via simulated SPI Rx
# Usage: send_spi_rx matrix|vector data_hex_string
proc send_spi_rx { spi_type data_hex } {
    # Define ports based on type
    if {$spi_type == "matrix"} {
        set sclk_port /qpu/rx_matrix_SCLK
        set ss_port   /qpu/rx_matrix_SS
        set mosi_port /qpu/rx_matrix_MOSI
    } elseif {$spi_type == "vector"} {
        set sclk_port /qpu/rx_vector_SCLK
        set ss_port   /qpu/rx_vector_SS
        set mosi_port /qpu/rx_vector_MOSI
    } else {
        echo "Error: Invalid SPI type specified in send_spi_rx"
        return
    }

    # Convert hex data to binary (ensure it's 72 bits)
    set data_bin [string trimleft [format "%072b" [expr {0x$data_hex}]]]
    if {[string length $data_bin] != 72} {
         echo "Error: Hex data '$data_hex' does not convert to 72 bits for $spi_type SPI."
         return
    }
    echo "Sending $spi_type SPI data: $data_bin"

    # Start SPI transaction
    force $ss_port 0
    force $sclk_port 0
    run 5 ns ; # Small delay after SS low

    # Clock out 72 bits (MSB first)
    for {set i 0} {$i < 72} {incr i} {
        set bit_val [string index $data_bin $i]
        force $mosi_port $bit_val
        run 5 ns; # MOSI setup time
        force $sclk_port 1
        run 10 ns; # SCLK high time
        force $sclk_port 0
        run 10 ns; # SCLK low time (ends cycle)
    }

    # End SPI transaction
    force $mosi_port 0 ; # Or 'Z' if needed
    run 5 ns
    force $ss_port 1
    run 10 ns; # Hold SS high

    # Release forces
    force -cancel $ss_port
    force -cancel $sclk_port
    force -cancel $mosi_port
    echo "$spi_type SPI word sent."
}

# Procedure to simulate SPI Tx clocking from master
# Usage: clock_spi_tx num_bits
proc clock_spi_tx { num_bits } {
    set sclk_port /qpu/tx_SCLK
    set ss_port   /qpu/tx_SS

    echo "Clocking $num_bits bits for SPI Tx..."
    force $ss_port 0
    force $sclk_port 0
    run 5 ns ; # Small delay after SS low

    for {set i 0} {$i < $num_bits} {incr i} {
        run 5 ns; # Let MISO stabilize if needed
        force $sclk_port 1
        run 10 ns; # SCLK high time (QPU should drive MISO)
        force $sclk_port 0
        run 10 ns; # SCLK low time
    }

    # End SPI transaction
    run 5 ns
    force $ss_port 1
    run 10 ns; # Hold SS high

    # Release forces
    force -cancel $ss_port
    force -cancel $sclk_port
    echo "SPI Tx clocking complete."
}


#==============================================================================
# Apply Stimulus
#==============================================================================

# 1. Initialize and Reset
echo "Initializing and Resetting QPU..."
force /qpu/clk 0 0 ns, 1 5 ns -repeat 10 ns  ;# 100 MHz clock
force /qpu/reset 1
force /qpu/enable 0 ; # Start disabled or in a known state
# Force SPI inputs inactive initially
force /qpu/rx_matrix_SCLK 0
force /qpu/rx_matrix_SS 1
force /qpu/rx_matrix_MOSI 0
force /qpu/rx_vector_SCLK 0
force /qpu/rx_vector_SS 1
force /qpu/rx_vector_MOSI 0
force /qpu/tx_SCLK 0
force /qpu/tx_SS 1

run 50 ns ; # Run for a few clock cycles with reset high

force /qpu/reset 0 ; # Deassert reset
run 20 ns ; # Wait for reset recovery

# 2. Receive Mode: Send Matrix Data
echo "Entering Receive Mode (enable=1)"
force /qpu/enable 1
run 20 ns

echo "Sending Matrix Data via SPI..."
# --- YOU MUST REPLACE THESE WITH ACTUAL 72-BIT HEX VALUES ---
# Example: Sending 4 elements for a 2x2 matrix (dimension=2)
# Adjust the number of calls based on your actual matrix size (dimension * dimension)
send_spi_rx matrix 0123456789ABCDEF01 ; # Element (0,0)
send_spi_rx matrix 111111111111111111 ; # Element (0,1)
send_spi_rx matrix 222222222222222222 ; # Element (1,0)
send_spi_rx matrix 333333333333333333 ; # Element (1,1)
# Add more send_spi_rx calls if dimension > 2

echo "Finished sending matrix data."
run 50 ns ; # Allow time for matrix assembly FSM to finish

# 3. Receive Mode: Send Vector Data
echo "Sending Vector Data via SPI..."
# --- YOU MUST REPLACE THESE WITH ACTUAL 72-BIT HEX VALUES ---
# Example: Sending 2 elements for dimension=2
# Adjust the number of calls based on your actual vector size (dimension)
send_spi_rx vector AAAAAAAAAAAAAAAAAA ; # Element 0
send_spi_rx vector BBBBBBBBBBBBBBBBBB ; # Element 1
# Add more send_spi_rx calls if dimension > 2

echo "Finished sending vector data."
run 50 ns ; # Allow time for vector assembly FSM to finish

# 4. Wait for Quantum Evolution and Psi Matrix Assembly
# The internal processes should start automatically when matrix_done and vector_done go high.
# We need to wait until the entire 30-step evolution and assembly is complete.
echo "Waiting for Quantum Evolution and Psi Matrix Assembly to complete..."
echo "Monitoring /qpu/psi_matrix_assemble_done"
# This wait can take a LONG time depending on the Pade/Inversion/QTE component latencies
# Increase the timeout significantly if needed.
run 500 us ; # Initial guess - ADJUST THIS TIME!
# Use 'when' condition for more robustness (requires simulation run control)
# Example: when {/qpu/psi_matrix_assemble_done == '1'} { echo "Psi Matrix Assembly Done!" } -else { run 10 us } -timeout 10000 us

# Add a final run to ensure the signal is seen if using the simple run command
run 100 ns

# Check if done (manual inspection or add conditional check)
if {[examine /qpu/psi_matrix_assemble_done] == "1"} {
    echo "OK: Psi Matrix Assembly Completed."
} else {
    echo "WARNING: Psi Matrix Assembly did NOT complete within the allotted time."
}

# 5. Transmit Mode: Clock out the Psi Matrix
echo "Entering Transmit Mode (enable=0)"
force /qpu/enable 0
run 50 ns ; # Allow mode change to settle

echo "Simulating Master Clocking for SPI Transmission..."
# Clock out the entire Psi Matrix (30 columns * dimension elements * 72 bits)
# Example for dimension = 2: 30 * 2 = 60 words = 60 * 72 bits
# --- ADJUST THE TOTAL NUMBER OF BITS BASED ON YOUR DIMENSION ---
set num_vector_elements 2 ; # Example: Set this based on qTypes dimension
set num_columns 30
set total_bits [expr $num_columns * $num_vector_elements * 72]
clock_spi_tx $total_bits

echo "Finished clocking SPI Tx."
run 100 ns

# 6. End Simulation
echo "Stimulus sequence finished."

#==============================================================================
# Run Simulation / Finalization
#==============================================================================
# Optional: Run for a bit longer to see final states
#run 200 ns

echo "Simulation complete. Check wave window and transcript."
