transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cyclonev_ver
vmap cyclonev_ver ./verilog_libs/cyclonev_ver
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/cyclonev_atoms.v}

vlib verilog_libs/cyclonev_hssi_ver
vmap cyclonev_hssi_ver ./verilog_libs/cyclonev_hssi_ver
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_hssi_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/cyclonev_hssi_atoms.v}

vlib verilog_libs/cyclonev_pcie_hip_ver
vmap cyclonev_pcie_hip_ver ./verilog_libs/cyclonev_pcie_hip_ver
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v}
vlog -vlog01compat -work cyclonev_pcie_hip_ver {c:/intelfpga_lite/19.1/quartus/eda/sim_lib/cyclonev_pcie_hip_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/mail/OneDrive/Desktop/quantum-fpga/db {C:/Users/mail/OneDrive/Desktop/quantum-fpga/db/mult_ol01.v}
vlog -vlog01compat -work work +incdir+C:/Users/mail/OneDrive/Desktop/quantum-fpga/db {C:/Users/mail/OneDrive/Desktop/quantum-fpga/db/mult_ne01.v}
vlog -vlog01compat -work work +incdir+C:/Users/mail/OneDrive/Desktop/quantum-fpga/db {C:/Users/mail/OneDrive/Desktop/quantum-fpga/db/mult_me01.v}
vlog -vlog01compat -work work +incdir+C:/Users/mail/OneDrive/Desktop/quantum-fpga/db {C:/Users/mail/OneDrive/Desktop/quantum-fpga/db/mult_oe01.v}
vlog -vlog01compat -work work +incdir+C:/Users/mail/OneDrive/Desktop/quantum-fpga/db {C:/Users/mail/OneDrive/Desktop/quantum-fpga/db/mult_0d01.v}
vlog -vlog01compat -work work +incdir+C:/Users/mail/OneDrive/Desktop/quantum-fpga/db {C:/Users/mail/OneDrive/Desktop/quantum-fpga/db/mult_0k01.v}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/Register_std_logic.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/fixed_float_types.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/fixed_pkg.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/triStateBuffer_std_logic.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/qTypes.vhd}
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

