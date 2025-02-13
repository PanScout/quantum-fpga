from myhdl import block, always_comb, Signal, intbv

def add_one(value):
    return value + 1

@block
def Incrementer(input_signal, output_signal):
    @always_comb
    def logic():
        output_signal.next = add_one(input_signal)
    return logic

# Signals
input_signal = Signal(intbv(0)[8:])
output_signal = Signal(intbv(0)[8:])

# Instantiate and convert
inc = Incrementer(input_signal, output_signal)
inc.convert(hdl='VHDL')
