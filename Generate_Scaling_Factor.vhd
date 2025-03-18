library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Generate_Scaling_Factor is
    Port (
        input  : in  cfixedHigh;
        S      : out cfixedHigh
    );
end Generate_Scaling_Factor;

architecture Structural of Generate_Scaling_Factor is

    -- Intermediate signals
    signal norm_in  : fixedHigh;    -- Real value to be processed by Norm_Theta_Ratio
    signal norm_out : fixedHigh;    -- Output from Norm_Theta_Ratio
    signal ceil_in  : cfixedHigh;   -- Input to Ceiling_Of_Log2 (constructed from norm_out)
    signal ceil_out : cfixedHigh;   -- Output from Ceiling_Of_Log2

    -- Component declaration for Norm_Theta_Ratio (operates on fixedHigh)
    component Norm_Theta_Ratio is
        Port (
            input  : in  fixedHigh;
            output : out fixedHigh
        );
    end component;

    -- Component declaration for Ceiling_Of_Log2 (operates on cfixedHigh)
    component Ceiling_Of_Log2 is
        port (
            scalar : in  cfixedHigh;
            result : out cfixedHigh
        );
    end component;

begin

    -- Extract the real part from the input cfixedHigh to feed Norm_Theta_Ratio
    norm_in <= input.re;

    -- Instantiate Norm_Theta_Ratio
    NormThetaRatio_inst: Norm_Theta_Ratio
        port map (
            input  => norm_in,
            output => norm_out
        );

    -- Reassemble norm_out into a cfixedHigh signal (with imaginary part zero)
    ceil_in.re <= norm_out;
    ceil_in.im <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";

    -- Instantiate Ceiling_Of_Log2
    CeilingOfLog2_inst: Ceiling_Of_Log2
        port map (
            scalar => ceil_in,
            result => ceil_out
        );

    -- The final result is assigned to S
    S <= ( re => resize(ceil_out.re + "0000000000000000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000000000000", fixedHigh'high, fixedHigh'low), im => ceil_out.im );




end Structural;
