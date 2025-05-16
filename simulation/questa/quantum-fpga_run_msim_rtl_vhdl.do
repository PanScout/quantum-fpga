transcript on
if ![file isdirectory vhdl_libs] {
	file mkdir vhdl_libs
}

vlib vhdl_libs/altera
vmap altera ./vhdl_libs/altera
vcom -93 -work altera {c:/arria10/quartus/eda/sim_lib/altera_syn_attributes.vhd}
vcom -93 -work altera {c:/arria10/quartus/eda/sim_lib/altera_standard_functions.vhd}
vcom -93 -work altera {c:/arria10/quartus/eda/sim_lib/alt_dspbuilder_package.vhd}
vcom -93 -work altera {c:/arria10/quartus/eda/sim_lib/altera_europa_support_lib.vhd}
vcom -93 -work altera {c:/arria10/quartus/eda/sim_lib/altera_primitives_components.vhd}
vcom -93 -work altera {c:/arria10/quartus/eda/sim_lib/altera_primitives.vhd}

vlib vhdl_libs/lpm
vmap lpm ./vhdl_libs/lpm
vcom -93 -work lpm {c:/arria10/quartus/eda/sim_lib/220pack.vhd}
vcom -93 -work lpm {c:/arria10/quartus/eda/sim_lib/220model.vhd}

vlib vhdl_libs/sgate
vmap sgate ./vhdl_libs/sgate
vcom -93 -work sgate {c:/arria10/quartus/eda/sim_lib/sgate_pack.vhd}
vcom -93 -work sgate {c:/arria10/quartus/eda/sim_lib/sgate.vhd}

vlib vhdl_libs/altera_mf
vmap altera_mf ./vhdl_libs/altera_mf
vcom -93 -work altera_mf {c:/arria10/quartus/eda/sim_lib/altera_mf_components.vhd}
vcom -93 -work altera_mf {c:/arria10/quartus/eda/sim_lib/altera_mf.vhd}

vlib vhdl_libs/altera_lnsim
vmap altera_lnsim ./vhdl_libs/altera_lnsim
vlog -sv -work altera_lnsim {c:/arria10/quartus/eda/sim_lib/mentor/altera_lnsim_for_vhdl.sv}
vcom -93 -work altera_lnsim {c:/arria10/quartus/eda/sim_lib/altera_lnsim_components.vhd}

vlib vhdl_libs/twentynm
vmap twentynm ./vhdl_libs/twentynm
vlog -vlog01compat -work twentynm {c:/arria10/quartus/eda/sim_lib/mentor/twentynm_atoms_ncrypt.v}
vcom -93 -work twentynm {c:/arria10/quartus/eda/sim_lib/twentynm_atoms.vhd}
vcom -93 -work twentynm {c:/arria10/quartus/eda/sim_lib/twentynm_components.vhd}

vlib vhdl_libs/twentynm_hssi
vmap twentynm_hssi ./vhdl_libs/twentynm_hssi
vlog -vlog01compat -work twentynm_hssi {c:/arria10/quartus/eda/sim_lib/mentor/twentynm_hssi_atoms_ncrypt.v}
vcom -93 -work twentynm_hssi {c:/arria10/quartus/eda/sim_lib/twentynm_hssi_components.vhd}
vcom -93 -work twentynm_hssi {c:/arria10/quartus/eda/sim_lib/twentynm_hssi_atoms.vhd}

vlib vhdl_libs/twentynm_hip
vmap twentynm_hip ./vhdl_libs/twentynm_hip
vlog -vlog01compat -work twentynm_hip {c:/arria10/quartus/eda/sim_lib/mentor/twentynm_hip_atoms_ncrypt.v}
vcom -93 -work twentynm_hip {c:/arria10/quartus/eda/sim_lib/twentynm_hip_components.vhd}
vcom -93 -work twentynm_hip {c:/arria10/quartus/eda/sim_lib/twentynm_hip_atoms.vhd}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/spi_receive.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/spi_transmit.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Register_std_logic.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/fixed_float_types.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/clock_divider.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/fixed_pkg.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/triStateBuffer_std_logic.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/qTypes.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/QPU.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/assemble_vector.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/assemble_psi_matrix.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/assemble_matrix.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Scale_CMatrix_Up.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Scale_CMatrix_Down.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/ReciprocalEstimation.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Quantum_Time_Evolution.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Quantum_FPGA.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Pade_Top_Level.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/padeNumerator.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/padeDenominator.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Norm_Theta_Ratio.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Newtons_Guess.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Multiply_Column_By_Scalar.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Multiply_By_Scalar_Then_Add.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Max_Of_CVector.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Matrix_Transpose.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Matrix_Plus_Scalar.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Matrix_Inversion_State_Machine.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Matrix_Inversion.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Matrix_By_Vector_Multiplication.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Matrix_By_Scalar_Multiplication.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Matrix_By_Matrix_Multiplication.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Insert_Imaginary_Time_Into_CMatrix.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Generate_Scaling_Factor.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Ceiling_Of_Log2.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Calculate_Norm_And_Compare.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Add_Vectors_Element_Wise.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Absolute_Row_Summation.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/disassemble_psi_matrix.vhd}

