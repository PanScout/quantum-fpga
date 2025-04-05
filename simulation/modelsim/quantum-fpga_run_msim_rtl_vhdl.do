transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/fixed_float_types.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/fixed_pkg.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/qTypes.vhd}
vcom -93 -work work {C:/Users/mail/OneDrive/Desktop/quantum-fpga/ReciprocalEstimation.vhd}

