vsim -gui work.matrixbyvectormultiplication
# vsim -gui work.matrixbyvectormultiplication 
# Start time: 03:40:59 on Jan 30,2025
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.fixed_float_types
# Loading ieee.math_real(body)
# Loading ieee.fixed_generic_pkg(body)
# Loading ieee.fixed_pkg
# Loading work.qtypes
# Loading work.matrixbyvectormultiplication(concurrent)
# Loading work.multiplythenaddvectors(concurrent)
# Loading work.multiplycolumnbyscalar(behavioral)
# Loading work.c_alu(behavioral)
# Loading work.cvector_adder(concurrent_arch)
add wave -position insertpoint  \
sim:/matrixbyvectormultiplication/A \
sim:/matrixbyvectormultiplication/V \
sim:/matrixbyvectormultiplication/Result \
sim:/matrixbyvectormultiplication/sum
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: mwd  Hostname: WIN-5F3DJOGAKN0  ProcessID: 9568
#           Attempting to use alternate WLF file "./wlftzccw2g".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftzccw2g
force -freeze sim:/matrixbyvectormultiplication/A(0)(0).re 0000000000000010000000000 0
force -freeze sim:/matrixbyvectormultiplication/A(0)(0).im 0000000000000010000000000 0
force -freeze sim:/matrixbyvectormultiplication/A(1)(0).re 0000000000000100000000000 0
force -freeze sim:/matrixbyvectormultiplication/A(1)(0).im 0000000000000100000000000 0
force -freeze sim:/matrixbyvectormultiplication/A(0)(1).re 0000000000000110000000000 0
force -freeze sim:/matrixbyvectormultiplication/A(0)(1).im 0000000000000110000000000 0
force -freeze sim:/matrixbyvectormultiplication/A(1)(1).re 0000000000001000000000000 0
force -freeze sim:/matrixbyvectormultiplication/A(1)(1).im 0000000000001000000000000 0
force -freeze sim:/matrixbyvectormultiplication/V(0).re 0000000000000100000000000 0
force -freeze sim:/matrixbyvectormultiplication/V(0).im 0000000000000100000000000 0
force -freeze sim:/matrixbyvectormultiplication/V(1).re 0000000000000110000000000 0
force -freeze sim:/matrixbyvectormultiplication/V(1).im 0000000000000110000000000 0
run