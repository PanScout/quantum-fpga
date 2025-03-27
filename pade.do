vsim -gui work.pade_top_level
# vsim -gui work.pade_top_level 
# Start time: 23:36:51 on Mar 17,2025
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.fixed_float_types
# Loading ieee.math_real(body)
# Loading ieee.fixed_generic_pkg(body)
# Loading ieee.fixed_pkg
# Loading work.qtypes(body)
# Loading work.pade_top_level(behavioral)
# Loading work.insert_imaginary_time_into_cmatrix(structural)
# Loading work.matrix_by_scalar_multiplication(concurrent)
# Loading work.calculate_norm_and_compare(structural)
# Loading work.absolute_row_summation(behavioral)
# Loading work.max_of_cvector(gen)
# Loading work.generate_scaling_factor(structural)
# Loading work.norm_theta_ratio(behav)
# Loading work.ceiling_of_log2(structural)
# Loading work.scale_cmatrixhigh_down(structural)
# Loading work.padenumerator(behavioral)
# Loading work.Matrix_Plus_Scalar(structural)
# Loading work.Matrix_By_Matrix_Multiplication(concurrent)
# Loading work.Matrix_By_Vector_Multiplication(concurrent)
# Loading work.Multiply_By_Scalar_Then_Add(concurrent)
# Loading work.Multiply_Column_By_Scalar(behavioral)
# Loading work.complex_alu_high(behavioral)
# Loading work.Add_Vectors_Element_Wise(concurrent_arch)
# Loading work.padedenominator(behavioral)
# Loading work.tristatebuffer_std_logic(behavioral)
# Loading work.matrix_inversion(toplevel)
# Loading work.newtons_guess(structural)
# Loading work.matrix_transpose(concurrent)
# Loading work.matrix_inversion_state_machine(behavioral)
# Loading work.register_std_logic(behavioral)
# Loading work.scale_cmatrixhigh_up(behavioral)
add wave -position insertpoint  \
sim:/pade_top_level/clk \
sim:/pade_top_level/reset \
sim:/pade_top_level/H \
sim:/pade_top_level/t \
sim:/pade_top_level/padeDone \
sim:/pade_top_level/output \
sim:/pade_top_level/IHTtoNormAndCompareandD1 \
sim:/pade_top_level/TorF \
sim:/pade_top_level/InfNormOut \
sim:/pade_top_level/IHTtoScalar \
sim:/pade_top_level/IHTdirect \
sim:/pade_top_level/ScalingFactorOut \
sim:/pade_top_level/ScaleDownOut \
sim:/pade_top_level/Mux2Out \
sim:/pade_top_level/PNumeratorOut \
sim:/pade_top_level/PDenominatorOut \
sim:/pade_top_level/InvOut \
sim:/pade_top_level/MatrixMultOut \
sim:/pade_top_level/MatriPowIn \
sim:/pade_top_level/Mux4In \
sim:/pade_top_level/ScaleUpOut \
sim:/pade_top_level/done \
sim:/pade_top_level/matrixInvDone \
sim:/pade_top_level/regStdLogicOut \
sim:/pade_top_level/tBuffStart \
sim:/pade_top_level/PNumDone \
sim:/pade_top_level/PDenDone \
sim:/pade_top_level/Mux4Out \
sim:/pade_top_level/reg1Out \
sim:/pade_top_level/reg2Out \
sim:/pade_top_level/tBuffOut \
sim:/pade_top_level/Hamiltonian
force -freeze sim:/pade_top_level/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/pade_top_level/reset 1 0
force -freeze sim:/pade_top_level/H(0)(0).re 0000000000000010000000000 0
force -freeze sim:/pade_top_level/H(0)(0).im 0000000000000000000000000 0
force -freeze sim:/pade_top_level/H(0)(1).re 0000000000000000000000000 0
force -freeze sim:/pade_top_level/H(0)(1).im 0000000000000010000000000 0
force -freeze sim:/pade_top_level/H(1)(0).re 0000000000000000000000000 0
force -freeze sim:/pade_top_level/H(1)(0).im 0000000000000000000000000 0
force -freeze sim:/pade_top_level/H(1)(1).re 0000000000000010000000000 0
force -freeze sim:/pade_top_level/H(1)(1).im 0000000000000000000000000 0
force -freeze sim:/pade_top_level/t.re 0000000000000001000000000 0
force -freeze sim:/pade_top_level/t.im 0000000000000000000000000 0
run
noforce sim:/pade_top_level/reset
force -freeze sim:/pade_top_level/reset 0 0
run 50000
run 50000

run 50000