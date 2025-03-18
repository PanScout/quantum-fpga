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
# Loading work.matrix_plus_scalar_high(structural)
# Loading work.matrix_by_matrix_multiplication_high(concurrent)
# Loading work.matrix_by_vector_multiplication_high(concurrent)
# Loading work.multiply_by_scalar_then_add_high(concurrent)
# Loading work.multiply_column_by_scalar_high(behavioral)
# Loading work.complex_alu_high(behavioral)
# Loading work.add_vectors_element_wise_high(concurrent_arch)
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
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Invert/GUESS_CALCULATOR/ONE_NORM
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Invert/GUESS_CALCULATOR/INF_NORM_A
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:TO_INTEGER (sfixed): metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Scale_Down
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /pade_top_level/Norm_And_Compare
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /pade_top_level/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: :ieee:fixed_generic_pkg:TO_INTEGER (sfixed): metavalue detected, returning 0
#    Time: 0 ps  Iteration: 1  Instance: /pade_top_level/Scale_Down
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /pade_top_level/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /pade_top_level/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /pade_top_level/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 5  Instance: /pade_top_level/Invert/GUESS_CALCULATOR/ONE_NORM
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 5  Instance: /pade_top_level/Invert/GUESS_CALCULATOR/INF_NORM_A
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 5  Region: /pade_top_level/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 5  Instance: /pade_top_level/Norm_And_Compare
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 6  Region: /pade_top_level/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 7  Region: /pade_top_level/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
noforce sim:/pade_top_level/reset
force -freeze sim:/pade_top_level/reset 0 0
run 50000
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 3200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 4100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 4200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 5 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 5900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 6100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 6800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 7700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 7900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 7900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 7900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 7900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 7900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 7900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 8 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 8600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 9500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 9900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 10400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 11300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 11800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 12200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 13100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 13700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 14 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 14900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 15600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 15800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 16700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 17500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 17600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 18500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 19400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 19400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 20300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 21200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 21300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 22100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 23 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 23200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 23900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 24800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 25100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 25700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 26600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 26900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 26900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 26900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 26900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 26900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 26900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 27 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 27500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 29 Error: 0.000000e+00
#    Time: 28400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 28900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 30 Error: 0.000000e+00
#    Time: 29300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 31 Error: 0.000000e+00
#    Time: 30200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 30800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 32 Error: 0.000000e+00
#    Time: 31100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 33 Error: 0.000000e+00
#    Time: 32 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 32700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 34 Error: 0.000000e+00
#    Time: 32900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 35 Error: 0.000000e+00
#    Time: 33800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 34600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 36 Error: 0.000000e+00
#    Time: 34700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 37 Error: 0.000000e+00
#    Time: 35600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 38 Error: 0.000000e+00
#    Time: 36500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 36500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 39 Error: 0.000000e+00
#    Time: 37400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 40 Error: 0.000000e+00
#    Time: 38300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 38400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 39400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 40300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 40300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 41200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 42100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 42200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 43 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 43900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 44100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 44800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 45700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 45900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 45900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 45900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 45900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 45900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 45900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 46 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 46600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 47500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 47900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 48400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 49300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 49800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
run 50000
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 50200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 51100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 51700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 52 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 52900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 53600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 53800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 54700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 55500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 55600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 56500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 57400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 57400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 58300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 59200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 59300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 60100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 61 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 61200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 61900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 62800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 63100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 63700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 29 Error: 0.000000e+00
#    Time: 64600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 64900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 64900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 64900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 64900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 64900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 64900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 65 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 30 Error: 0.000000e+00
#    Time: 65500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 31 Error: 0.000000e+00
#    Time: 66400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 66900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 32 Error: 0.000000e+00
#    Time: 67300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 33 Error: 0.000000e+00
#    Time: 68200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 68800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 34 Error: 0.000000e+00
#    Time: 69100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 35 Error: 0.000000e+00
#    Time: 70 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 70700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 36 Error: 0.000000e+00
#    Time: 70900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 37 Error: 0.000000e+00
#    Time: 71800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 72600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 38 Error: 0.000000e+00
#    Time: 72700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 39 Error: 0.000000e+00
#    Time: 73600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 40 Error: 0.000000e+00
#    Time: 74500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 74500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 75600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 76400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 76500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 77400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 78300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 78300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 79200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 80100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 80200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 81 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 81900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82 ns  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 82100 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 82800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 83700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 83900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 83900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 83900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 83900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 83900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 83900 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 84 ns  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 84600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 85500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85800 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 85900 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 86400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 87300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87700 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 87800 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 88200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 89100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89600 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 89700 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 90 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 90900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91500 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 91600 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 91800 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 92700 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93400 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 93500 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 93600 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 94500 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95300 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 95400 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 95400 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 96300 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 97200 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97200 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 97300 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 98100 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 99 ns  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99100 ps  Iteration: 3  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 99200 ps  Iteration: 11  Region: /pade_top_level/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 99900 ps  Iteration: 0  Instance: /pade_top_level/Invert/INVERSION_CORE
run 50000