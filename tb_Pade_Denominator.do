vsim -gui work.tb_pade_denominator 
# Start time: 01:07:26 on Feb 09,2025
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.fixed_float_types
# Loading ieee.math_real(body)
# Loading ieee.fixed_generic_pkg(body)
# Loading ieee.fixed_pkg
# Loading work.qtypes(body)
# Loading work.tb_pade_denominator(behavioral)
# Loading work.pade_denominator(structural)
# Loading work.Matrix_Plus_Scalar(structural)
# Loading work.Matrix_By_Matrix_Multiplication(concurrent)
# Loading work.Matrix_By_Vector_Multiplication(concurrent)
# Loading work.Multiply_By_Scalar_Then_Add(concurrent)
# Loading work.Multiply_Column_By_Scalar(behavioral)
# Loading work.complex_alu_high(behavioral)
# Loading work.Add_Vectors_Element_Wise(concurrent_arch)
# ** Warning: Design size of 13886 statements exceeds ModelSim-Intel FPGA Starter Edition recommended capacity.
# Expect performance to be adversely affected.
add wave -position insertpoint  \
sim:/tb_pade_denominator/B \
sim:/tb_pade_denominator/P \
sim:/tb_pade_denominator/clk \
sim:/tb_pade_denominator/CLK_PERIOD \
sim:/tb_pade_denominator/MATRIX_SIZE \
sim:/tb_pade_denominator/DELTA \
sim:/tb_pade_denominator/EXPECTED_1x1
run
# ** Note: Test: Matrix filled with ones
#    Time: 0 ps  Iteration: 0  Instance: /tb_pade_denominator
# ** Warning: Warning: Verification skipped for non-1x1 matrix
#    Time: 0 ps  Iteration: 0  Instance: /tb_pade_denominator
# ** Note: All tests completed
#    Time: 0 ps  Iteration: 0  Instance: /tb_pade_denominator
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U16/input_cMatrixH \
sim:/tb_pade_denominator/uut/U16/scalar \
sim:/tb_pade_denominator/uut/U16/output_cMatrixH
run
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U0/input_cMatrixH \
sim:/tb_pade_denominator/uut/U0/scalar \
sim:/tb_pade_denominator/uut/U0/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U1/A \
sim:/tb_pade_denominator/uut/U1/B \
sim:/tb_pade_denominator/uut/U1/C
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U2/input_cMatrixH \
sim:/tb_pade_denominator/uut/U2/scalar \
sim:/tb_pade_denominator/uut/U2/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U3/A \
sim:/tb_pade_denominator/uut/U3/B \
sim:/tb_pade_denominator/uut/U3/C
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U4/input_cMatrixH \
sim:/tb_pade_denominator/uut/U4/scalar \
sim:/tb_pade_denominator/uut/U4/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U5/A \
sim:/tb_pade_denominator/uut/U5/B \
sim:/tb_pade_denominator/uut/U5/C
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U6/input_cMatrixH \
sim:/tb_pade_denominator/uut/U6/scalar \
sim:/tb_pade_denominator/uut/U6/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U7/A \
sim:/tb_pade_denominator/uut/U7/B \
sim:/tb_pade_denominator/uut/U7/C
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U8/input_cMatrixH \
sim:/tb_pade_denominator/uut/U8/scalar \
sim:/tb_pade_denominator/uut/U8/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U9/A \
sim:/tb_pade_denominator/uut/U9/B \
sim:/tb_pade_denominator/uut/U9/C
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U10/input_cMatrixH \
sim:/tb_pade_denominator/uut/U10/scalar \
sim:/tb_pade_denominator/uut/U10/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U11/A \
sim:/tb_pade_denominator/uut/U11/B \
sim:/tb_pade_denominator/uut/U11/C
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U12/input_cMatrixH \
sim:/tb_pade_denominator/uut/U12/scalar \
sim:/tb_pade_denominator/uut/U12/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U13/A \
sim:/tb_pade_denominator/uut/U13/B \
sim:/tb_pade_denominator/uut/U13/C
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U14/input_cMatrixH \
sim:/tb_pade_denominator/uut/U14/scalar \
sim:/tb_pade_denominator/uut/U14/output_cMatrixH
add wave -position insertpoint  \
sim:/tb_pade_denominator/uut/U15/A \
sim:/tb_pade_denominator/uut/U15/B \
sim:/tb_pade_denominator/uut/U15/C
run