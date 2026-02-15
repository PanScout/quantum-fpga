GHDL      := ghdl
STD       := --std=93 -C -frelaxed
BUILDDIR  := build
VCD       := $(BUILDDIR)/qpu_tb.vcd
STOP_TIME := --stop-time=20ms

RTL := src/rtl
TB  := src/tb

# All source files in compilation order
SRCS := \
	$(RTL)/pkg/fixed_float_types.vhd \
	$(RTL)/pkg/fixed_pkg.vhd \
	$(RTL)/pkg/qtypes.vhd \
	$(RTL)/math/absolute_row_summation.vhd \
	$(RTL)/math/add_vectors_element_wise.vhd \
	$(RTL)/spi/assemble_matrix.vhd \
	$(RTL)/spi/assemble_psi_matrix.vhd \
	$(RTL)/spi/assemble_vector.vhd \
	$(RTL)/math/ceiling_of_log2.vhd \
	$(RTL)/util/clock_divider.vhd \
	$(RTL)/util/hex_to_7seg.vhd \
	$(RTL)/math/matrix_addition.vhd \
	$(RTL)/math/matrix_by_scalar_multiplication.vhd \
	$(RTL)/math/add_scalar_to_diagonal.vhd \
	$(RTL)/math/matrix_transpose.vhd \
	$(RTL)/math/max_real_part_of_cvector.vhd \
	$(RTL)/math/multiply_column_by_scalar.vhd \
	$(RTL)/math/norm_theta_ratio.vhd \
	$(RTL)/inversion/linear_reciprocal_approximation.vhd \
	$(RTL)/util/register_cfixed.vhd \
	$(RTL)/util/register_cmatrix.vhd \
	$(RTL)/util/register_cvector.vhd \
	$(RTL)/util/register_std_logic.vhd \
	$(RTL)/pade/scale_cmatrix_down.vhd \
	$(RTL)/spi/spi_receive.vhd \
	$(RTL)/spi/spi_transmit.vhd \
	$(RTL)/util/tri_state_buffer_cmatrix.vhd \
	$(RTL)/util/tri_state_buffer_cvector.vhd \
	$(RTL)/util/delayed_pulse_generator.vhd \
	$(RTL)/math/calculate_norm_and_compare.vhd \
	$(RTL)/spi/disassemble_matrix.vhd \
	$(RTL)/spi/disassemble_psi_matrix.vhd \
	$(RTL)/math/generate_scaling_factor.vhd \
	$(RTL)/pade/insert_imaginary_time_into_cmatrix.vhd \
	$(RTL)/math/matrix_by_vector_multiplication.vhd \
	$(RTL)/math/multiply_by_scalar_then_add.vhd \
	$(RTL)/math/matrix_by_matrix_multiplication.vhd \
	$(RTL)/inversion/matrix_inversion_initial_guess.vhd \
	$(RTL)/inversion/matrix_inversion_state_machine.vhd \
	$(RTL)/inversion/matrix_inversion.vhd \
	$(RTL)/pade/pade_denominator.vhd \
	$(RTL)/pade/pade_numerator.vhd \
	$(RTL)/pade/repeated_matrix_squaring.vhd \
	$(RTL)/pade/pade_top_level.vhd \
	$(RTL)/top/quantum_fpga.vhd \
	$(RTL)/top/quantum_time_evolution.vhd \
	$(RTL)/top/qpu.vhd \
	$(TB)/qpu_tb.vhd

.PHONY: all analyze elaborate sim plot view clean

all: sim

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

analyze: | $(BUILDDIR)
	$(GHDL) -a $(STD) --workdir=$(BUILDDIR) $(SRCS)

elaborate: analyze
	$(GHDL) -e $(STD) --workdir=$(BUILDDIR) -o $(BUILDDIR)/qpu_tb qpu_tb

sim: elaborate
	cd $(BUILDDIR) && $(GHDL) -r $(STD) --workdir=. qpu_tb --vcd=qpu_tb.vcd $(STOP_TIME)

plot: sim
	python3 python/plot_results.py

view: sim
	surfer $(VCD) &

clean:
	rm -rf $(BUILDDIR)
