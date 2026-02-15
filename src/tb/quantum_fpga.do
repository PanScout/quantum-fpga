vsim -gui work.quantum_fpga
# vsim -gui work.quantum_fpga 
# Start time: 01:19:26 on Mar 18,2025
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.fixed_float_types
# Loading ieee.math_real(body)
# Loading ieee.fixed_generic_pkg(body)
# Loading ieee.fixed_pkg
# Loading work.qtypes(body)
# Loading work.quantum_fpga(behavioral)
# Loading work.register_cfixed(behavioral)
# Loading work.register_cmatrix(behavioral)
# Loading work.register_cvector(behavioral)
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
# Loading work.tristatebuffer_cmatrix(behavioral)
# Loading work.matrix_by_vector_multiplication(concurrent)
# Loading work.multiply_by_scalar_then_add(concurrent)
# Loading work.multiply_column_by_scalar(behavioral)
# Loading work.complex_alu(behavioral)
# Loading work.add_vectors_element_wise(concurrent_arch)
# Loading work.tristatebuffer_cvector(behavioral)
# Loading work.probability_cvector(behavioral)
add wave -position insertpoint  \
sim:/quantum_fpga/clk \
sim:/quantum_fpga/reset \
sim:/quantum_fpga/H \
sim:/quantum_fpga/psi \
sim:/quantum_fpga/t \
sim:/quantum_fpga/loadTime \
sim:/quantum_fpga/loadHamiltonian \
sim:/quantum_fpga/loadPsi \
sim:/quantum_fpga/tEnable \
sim:/quantum_fpga/done \
sim:/quantum_fpga/output \
sim:/quantum_fpga/timeOut \
sim:/quantum_fpga/HamiltonianOut \
sim:/quantum_fpga/psiOut \
sim:/quantum_fpga/UxPsiOut \
sim:/quantum_fpga/stateOut \
sim:/quantum_fpga/probabilities \
sim:/quantum_fpga/padeOutput \
sim:/quantum_fpga/padeBuffOut \
sim:/quantum_fpga/padeDone
force -freeze sim:/quantum_fpga/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/quantum_fpga/reset 1 0, 0 {50 ps} -r 100
force -freeze sim:/quantum_fpga/reset 1 0
force -freeze sim:/quantum_fpga/H(0)(0).re 0000000000000010000000000 0
force -freeze sim:/quantum_fpga/H(0)(0).im 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/H(0)(1).re 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/H(0)(1).im 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/H(1)(0).re 0000000000000000000000000 0
noforce sim:/quantum_fpga/H(1)(0).im
force -freeze sim:/quantum_fpga/H(1)(0).im 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/H(1)(1).re 0000000000000010000000000 0
force -freeze sim:/quantum_fpga/H(1)(1).im 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/psi(0).re 0000000000000010000000000 0
force -freeze sim:/quantum_fpga/psi(0).im 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/psi(1).re 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/psi(1).im 0000000000000000000000000 0
force -freeze sim:/quantum_fpga/t.re 0000000000000001000000000 0
force -freeze sim:/quantum_fpga/t.im 0000000000000000000000000 0
run
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/ONE_NORM
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/INF_NORM_A
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:TO_INTEGER (sfixed): metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Scale_Down
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Instance: /quantum_fpga/pade/Norm_And_Compare
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 0  Region: /quantum_fpga/pade/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 1  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: :ieee:fixed_generic_pkg:TO_INTEGER (sfixed): metavalue detected, returning 0
#    Time: 0 ps  Iteration: 1  Instance: /quantum_fpga/pade/Scale_Down
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Instance: /quantum_fpga/pade/Gen_Scaling_Factor/CeilingOfLog2_inst
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 2  Region: /quantum_fpga/pade/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: NUMERIC_STD."=": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 3  Region: /quantum_fpga/pade/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 5  Instance: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/ONE_NORM
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 5  Instance: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/INF_NORM_A
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 5  Instance: /quantum_fpga/pade/Norm_And_Compare
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 6  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/INF_NORM_A/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 7  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/ONE_NORM/norm_inst/cmp_gen(1)
# ** Warning: :ieee:fixed_generic_pkg:">": metavalue detected, returning FALSE
#    Time: 0 ps  Iteration: 7  Region: /quantum_fpga/pade/Norm_And_Compare/norm_inst/cmp_gen(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 0 ps  Iteration: 12  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
force -freeze sim:/quantum_fpga/reset 1 0
force -freeze sim:/quantum_fpga/reset 0 0
force -freeze sim:/quantum_fpga/reset 1 0
run
force -freeze sim:/quantum_fpga/reset 0 0
force -freeze sim:/quantum_fpga/loadTime 1 0
force -freeze sim:/quantum_fpga/loadHamiltonian 1 0
force -freeze sim:/quantum_fpga/loadPsi 1 0
force -freeze sim:/quantum_fpga/tEnable 0 0
run
run 40000
run 40000
run
run
force -freeze sim:/quantum_fpga/reset 0 0
run 40000
noforce sim:/quantum_fpga/reset
force -freeze sim:/quantum_fpga/reset 0 0
run 40000
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 122700 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(0)/gen_scaling_row(0)
# ** Error: :ieee:fixed_generic_pkg:DIVIDE(sfixed) Division by zero
#    Time: 122700 ps  Iteration: 3  Region: /quantum_fpga/pade/Invert/GUESS_CALCULATOR/gen_scaling(1)/gen_scaling_row(1)
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 123600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 124500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 125400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 126300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 127200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 128100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 129 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 129900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 130800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 131700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 132600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 133500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 134400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 135300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 136200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 137100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 138 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 138900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 139800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 140700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 141600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 142500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 143400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 144300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 145200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 146100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 147 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 147900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 29 Error: 0.000000e+00
#    Time: 148800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 30 Error: 0.000000e+00
#    Time: 149700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 31 Error: 0.000000e+00
#    Time: 150600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 32 Error: 0.000000e+00
#    Time: 151500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 33 Error: 0.000000e+00
#    Time: 152400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 34 Error: 0.000000e+00
#    Time: 153300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 35 Error: 0.000000e+00
#    Time: 154200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 36 Error: 0.000000e+00
#    Time: 155100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 37 Error: 0.000000e+00
#    Time: 156 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 38 Error: 0.000000e+00
#    Time: 156900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 39 Error: 0.000000e+00
#    Time: 157800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 40 Error: 0.000000e+00
#    Time: 158700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 159800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
run 40000
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 160700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 161600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 162500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 163400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 164300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 165200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 166100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 167 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 167900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 168800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 169700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 170600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 171500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 172400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 173300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 174200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 175100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 176 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 176900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 177800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 178700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 179600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 180500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 181400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 182300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 183200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 184100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 29 Error: 0.000000e+00
#    Time: 185 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 30 Error: 0.000000e+00
#    Time: 185900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 31 Error: 0.000000e+00
#    Time: 186800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 32 Error: 0.000000e+00
#    Time: 187700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 33 Error: 0.000000e+00
#    Time: 188600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 34 Error: 0.000000e+00
#    Time: 189500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 35 Error: 0.000000e+00
#    Time: 190400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 36 Error: 0.000000e+00
#    Time: 191300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 37 Error: 0.000000e+00
#    Time: 192200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 38 Error: 0.000000e+00
#    Time: 193100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 39 Error: 0.000000e+00
#    Time: 194 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 40 Error: 0.000000e+00
#    Time: 194900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 196 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 196900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 197800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 198700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 199600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 200500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
run 40000
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 201400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 202300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 203200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 204100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 205 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 205900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 206800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 207700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 208600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 209500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 210400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 211300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 212200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 213100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 214 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 214900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 215800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 216700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 217600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 218500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 219400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 220300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 29 Error: 0.000000e+00
#    Time: 221200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 30 Error: 0.000000e+00
#    Time: 222100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 31 Error: 0.000000e+00
#    Time: 223 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 32 Error: 0.000000e+00
#    Time: 223900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 33 Error: 0.000000e+00
#    Time: 224800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 34 Error: 0.000000e+00
#    Time: 225700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 35 Error: 0.000000e+00
#    Time: 226600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 36 Error: 0.000000e+00
#    Time: 227500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 37 Error: 0.000000e+00
#    Time: 228400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 38 Error: 0.000000e+00
#    Time: 229300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 39 Error: 0.000000e+00
#    Time: 230200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 40 Error: 0.000000e+00
#    Time: 231100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 232200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 233100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 234 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 234900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 235800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 236700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 237600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 238500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 239400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 240300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
force -freeze sim:/quantum_fpga/tEnable 1 0

force -freeze sim:/quantum_fpga/tEnable 1 0
run 40000
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 241200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 242100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 243 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 243900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 244800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 245700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 246600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 247500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 248400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 249300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 250200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 251100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 252 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 252900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 253800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 254700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 255600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 256500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 29 Error: 0.000000e+00
#    Time: 257400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 30 Error: 0.000000e+00
#    Time: 258300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 31 Error: 0.000000e+00
#    Time: 259200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 32 Error: 0.000000e+00
#    Time: 260100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 33 Error: 0.000000e+00
#    Time: 261 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 34 Error: 0.000000e+00
#    Time: 261900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 35 Error: 0.000000e+00
#    Time: 262800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 36 Error: 0.000000e+00
#    Time: 263700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 37 Error: 0.000000e+00
#    Time: 264600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 38 Error: 0.000000e+00
#    Time: 265500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 39 Error: 0.000000e+00
#    Time: 266400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 40 Error: 0.000000e+00
#    Time: 267300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 268400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 269300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 270200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 271100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 272 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 272900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 273800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 274700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 275600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 276500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 277400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 278300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 279200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 280100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
run 40000
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 281 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 281900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 282800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 283700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 19 Error: 0.000000e+00
#    Time: 284600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 20 Error: 0.000000e+00
#    Time: 285500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 21 Error: 0.000000e+00
#    Time: 286400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 22 Error: 0.000000e+00
#    Time: 287300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 23 Error: 0.000000e+00
#    Time: 288200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 24 Error: 0.000000e+00
#    Time: 289100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 25 Error: 0.000000e+00
#    Time: 290 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 26 Error: 0.000000e+00
#    Time: 290900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 27 Error: 0.000000e+00
#    Time: 291800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 28 Error: 0.000000e+00
#    Time: 292700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 29 Error: 0.000000e+00
#    Time: 293600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 30 Error: 0.000000e+00
#    Time: 294500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 31 Error: 0.000000e+00
#    Time: 295400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 32 Error: 0.000000e+00
#    Time: 296300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 33 Error: 0.000000e+00
#    Time: 297200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 34 Error: 0.000000e+00
#    Time: 298100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 35 Error: 0.000000e+00
#    Time: 299 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 36 Error: 0.000000e+00
#    Time: 299900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 37 Error: 0.000000e+00
#    Time: 300800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 38 Error: 0.000000e+00
#    Time: 301700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 39 Error: 0.000000e+00
#    Time: 302600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 40 Error: 0.000000e+00
#    Time: 303500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 1 Error: 0.000000e+00
#    Time: 304600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 2 Error: 0.000000e+00
#    Time: 305500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 3 Error: 0.000000e+00
#    Time: 306400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 4 Error: 0.000000e+00
#    Time: 307300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 5 Error: 0.000000e+00
#    Time: 308200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 6 Error: 0.000000e+00
#    Time: 309100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 7 Error: 0.000000e+00
#    Time: 310 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 8 Error: 0.000000e+00
#    Time: 310900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 9 Error: 0.000000e+00
#    Time: 311800 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 10 Error: 0.000000e+00
#    Time: 312700 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 11 Error: 0.000000e+00
#    Time: 313600 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 12 Error: 0.000000e+00
#    Time: 314500 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 13 Error: 0.000000e+00
#    Time: 315400 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 14 Error: 0.000000e+00
#    Time: 316300 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 15 Error: 0.000000e+00
#    Time: 317200 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 16 Error: 0.000000e+00
#    Time: 318100 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 17 Error: 0.000000e+00
#    Time: 319 ns  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
# ** Note: Iteration: 18 Error: 0.000000e+00
#    Time: 319900 ps  Iteration: 0  Instance: /quantum_fpga/pade/Invert/INVERSION_CORE
