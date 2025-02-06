vsim -gui work.matrixbymatrixmultiplication
# vsim -gui work.matrixbymatrixmultiplication 
# Start time: 04:11:42 on Jan 30,2025
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.fixed_float_types
# Loading ieee.math_real(body)
# Loading ieee.fixed_generic_pkg(body)
# Loading ieee.fixed_pkg
# Loading work.qtypes
# Loading work.matrixbymatrixmultiplication(concurrent)
# Loading work.matrixbyvectormultiplication(concurrent)
# Loading work.multiplythenaddvectors(concurrent)
# Loading work.multiplycolumnbyscalar(behavioral)
# Loading work.c_alu(behavioral)
# Loading work.cvector_adder(concurrent_arch)
add wave -position insertpoint  \
sim:/matrixbymatrixmultiplication/A \
sim:/matrixbymatrixmultiplication/B \
sim:/matrixbymatrixmultiplication/C
# ** Warning: (vsim-WLF-5000) WLF file currently in use: vsim.wlf
#           File in use by: mwd  Hostname: WIN-5F3DJOGAKN0  ProcessID: 9568
#           Attempting to use alternate WLF file "./wlftwj7bdz".
# ** Warning: (vsim-WLF-5001) Could not open WLF file: vsim.wlf
#           Using alternate file: ./wlftwj7bdz
force -freeze sim:/matrixbymatrixmultiplication/A(0)(0).re 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/A(0)(0).im 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/A(0)(1).re 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/A(0)(1).im 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(0)(0).re 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(0)(0).im 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(1)(0).re 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(1)(0).im 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/A(1)(0).re 0000000000000100000000000 0
force -freeze sim:/matrixbymatrixmultiplication/A(1)(0).im 0000000000000100000000000 0
force -freeze sim:/matrixbymatrixmultiplication/A(1)(1).re 0000000000000100000000000 0
force -freeze sim:/matrixbymatrixmultiplication/A(1)(1).im 0000000000000100000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(1)(0).re 0000000000000010000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(0)(1).re 0000000000001000000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(0)(1).im 0000000000001000000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(1)(1).re 0000000000001000000000000 0
force -freeze sim:/matrixbymatrixmultiplication/B(1)(1).im 0000000000001000000000000 0
run