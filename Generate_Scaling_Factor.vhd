library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed64.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Generate_Scaling_Factor is
    Port (
        input  : in  cfixed64;
        S      : out cfixed64
    );
end Generate_Scaling_Factor;

architecture Structural of Generate_Scaling_Factor is

    -- Intermediate signals
    signal norm_in  : fixed64;    -- Real value to be processed by Norm_Theta_Ratio
    signal norm_out : fixed64;    -- Output from Norm_Theta_Ratio
    signal ceil_in  : cfixed64;   -- Input to Ceiling_Of_Log2 (constructed from norm_out)
    signal ceil_out : cfixed64;   -- Output from Ceiling_Of_Log2

    -- Component declaration for Norm_Theta_Ratio (operates on fixed64)
    component Norm_Theta_Ratio is
        Port (
            input  : in  fixed64;
            output : out fixed64
        );
    end component;

    -- Component declaration for Ceiling_Of_Log2 (operates on cfixed64)
    component Ceiling_Of_Log2 is
        port (
            scalar : in  cfixed64;
            result : out cfixed64
        );
    end component;

begin

    -- Extract the real part from the input cfixed64 to feed Norm_Theta_Ratio
    norm_in <= input.re;

    -- Instantiate Norm_Theta_Ratio
    NormThetaRatio_inst: Norm_Theta_Ratio
        port map (
            input  => norm_in,
            output => norm_out
        );

    -- Reassemble norm_out into a cfixed64 signal (with imaginary part zero)
    ceil_in.re <= norm_out;
    --ceil_in.im <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    ceil_in.im <= to_sfixed(0.0, fixed64'high, fixed64'low);
    -- Instantiate Ceiling_Of_Log2
    CeilingOfLog2_inst: Ceiling_Of_Log2
        port map (
            scalar => ceil_in,
            result => ceil_out
        );

    -- The final result is assigned to S
    --S <= ( re => resize(ceil_out.re + "0000000000000000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000000000000", fixed64'high, fixed64'low), im => ceil_out.im );
    S <= ( re => resize(ceil_out.re + to_sfixed(3.0, fixed64'high, fixed64'low), fixed64'high, fixed64'low), im => ceil_out.im );



end Structural;
