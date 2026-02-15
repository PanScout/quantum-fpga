library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity generate_scaling_factor is
    Port (
        input  : in  csfixed36;
        S      : out csfixed36
    );
end generate_scaling_factor;

architecture Structural of generate_scaling_factor is

    -- Intermediate signals
    signal norm_in  : sfixed36;    -- Real value to be processed by norm_theta_ratio
    signal norm_out : sfixed36;    -- Output from norm_theta_ratio
    signal ceil_in  : csfixed36;   -- Input to ceiling_of_log2 (constructed from norm_out)
    signal ceil_out : csfixed36;   -- Output from ceiling_of_log2

    -- Component declaration for norm_theta_ratio (operates on sfixed36)
    component norm_theta_ratio is
        Port (
            input  : in  sfixed36;
            output : out sfixed36
        );
    end component;

    -- Component declaration for ceiling_of_log2 (operates on csfixed36)
    component ceiling_of_log2 is
        port (
            scalar : in  csfixed36;
            result : out csfixed36
        );
    end component;

begin

    -- Extract the real part from the input csfixed36 to feed norm_theta_ratio
    norm_in <= input.re;

    -- Instantiate norm_theta_ratio
    NormThetaRatio_inst: norm_theta_ratio
        port map (
            input  => norm_in,
            output => norm_out
        );

    -- Reassemble norm_out into a csfixed36 signal (with imaginary part zero)
    ceil_in.re <= norm_out;
    --ceil_in.im <= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    ceil_in.im <= to_sfixed(0.0, sfixed36'high, sfixed36'low);
    -- Instantiate ceiling_of_log2
    CeilingOfLog2_inst: ceiling_of_log2
        port map (
            scalar => ceil_in,
            result => ceil_out
        );

    -- The final result is assigned to S
    --S <= ( re => resize(ceil_out.re + "0000000000000000000000000000000000000000000000000110000000000000000000000000000000000000000000000000000000000000000", sfixed36'high, sfixed36'low), im => ceil_out.im );
    S <= ( re => resize(ceil_out.re + to_sfixed(3.0, sfixed36'high, sfixed36'low), sfixed36'high, sfixed36'low), im => ceil_out.im );



end Structural;
