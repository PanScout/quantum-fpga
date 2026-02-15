GHDL      := ghdl
STD       := --std=93 -C -frelaxed
WORKDIR   := work
VCD       := qpu_tb.vcd
STOP_TIME := --stop-time=20ms

RTL := src/rtl
TB  := src/tb

# All source files in compilation order
SRCS := \
	$(RTL)/fixed_float_types.vhd \
	$(RTL)/fixed_pkg.vhd \
	$(RTL)/qtypes.vhd \
	$(RTL)/absolute_row_summation.vhd \
	$(RTL)/add_vectors_element_wise.vhd \
	$(RTL)/assemble_matrix.vhd \
	$(RTL)/assemble_psi_matrix.vhd \
	$(RTL)/assemble_vector.vhd \
	$(RTL)/ceiling_of_log2.vhd \
	$(RTL)/clock_divider.vhd \
	$(RTL)/hex_to_7seg.vhd \
	$(RTL)/matrix_addition.vhd \
	$(RTL)/matrix_by_scalar_multiplication.vhd \
	$(RTL)/matrix_plus_scalar.vhd \
	$(RTL)/matrix_transpose.vhd \
	$(RTL)/max_of_cvector.vhd \
	$(RTL)/multiply_column_by_scalar.vhd \
	$(RTL)/norm_theta_ratio.vhd \
	$(RTL)/reciprocal_estimation.vhd \
	$(RTL)/register_cfixed.vhd \
	$(RTL)/register_cmatrix.vhd \
	$(RTL)/register_cvector.vhd \
	$(RTL)/register_std_logic.vhd \
	$(RTL)/scale_cmatrix_down.vhd \
	$(RTL)/spi_receive.vhd \
	$(RTL)/spi_transmit.vhd \
	$(RTL)/tri_state_buffer_cmatrix.vhd \
	$(RTL)/tri_state_buffer_cvector.vhd \
	$(RTL)/tri_state_buffer_std_logic.vhd \
	$(RTL)/calculate_norm_and_compare.vhd \
	$(RTL)/disassemble_matrix.vhd \
	$(RTL)/disassemble_psi_matrix.vhd \
	$(RTL)/generate_scaling_factor.vhd \
	$(RTL)/insert_imaginary_time_into_cmatrix.vhd \
	$(RTL)/matrix_by_vector_multiplication.vhd \
	$(RTL)/multiply_by_scalar_then_add.vhd \
	$(RTL)/matrix_by_matrix_multiplication.vhd \
	$(RTL)/newtons_guess.vhd \
	$(RTL)/matrix_inversion_state_machine.vhd \
	$(RTL)/matrix_inversion.vhd \
	$(RTL)/pade_denominator.vhd \
	$(RTL)/pade_numerator.vhd \
	$(RTL)/scale_cmatrix_up.vhd \
	$(RTL)/pade_top_level.vhd \
	$(RTL)/quantum_fpga.vhd \
	$(RTL)/quantum_time_evolution.vhd \
	$(RTL)/qpu.vhd \
	$(TB)/qpu_tb.vhd

.PHONY: all analyze elaborate sim view clean

all: sim

analyze:
	$(GHDL) -a $(STD) $(SRCS)

elaborate: analyze
	$(GHDL) -e $(STD) qpu_tb

sim: elaborate
	$(GHDL) -r $(STD) qpu_tb --vcd=$(VCD) $(STOP_TIME)

view: sim
	surfer $(VCD) &

clean:
	$(GHDL) --clean
	rm -f $(VCD) *.cf *.o
