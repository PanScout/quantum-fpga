library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity timePiGate is
    Port (
        t_in  : in  fixed;     -- Input time value (14.10 format)
        t_out : out fixed      -- Output (t_in or high-impedance)
    );
end timePiGate;

architecture Concurrent of timePiGate is
    -- Pre-calculated ? approximation in fixed(14.10) format
    constant PI : fixed := to_sfixed(3.1416015625, fixed'high, fixed'low);
    
    -- Tolerance adjusted for fixed(14.10) precision
    constant EPSILON : real := 0.002;  -- ~2 LSBs of 10 fractional bits

    -- Pure combinational check function
    function is_pi_multiple(t: fixed) return boolean is
        variable ratio : fixed := resize(t / PI, t'high, t'low);
        variable int_part : fixed := resize(ratio, ratio'high, 0);
        variable frac_part : fixed := ratio - int_part;
    begin
        return abs(to_real(frac_part)) < EPSILON;
    end function;

begin
    -- Concurrent output generation
    gen_output: for i in t_out'range generate
        t_out(i) <= t_in(i) when is_pi_multiple(t_in) else 'Z';
    end generate gen_output;
end architecture Concurrent;
