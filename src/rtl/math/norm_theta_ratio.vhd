library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.all;

entity norm_theta_ratio is
    Port (
        input  : in  sfixed36;
        output : out sfixed36
    );
end norm_theta_ratio;

architecture behav of norm_theta_ratio is
    --constant DIVISOR : sfixed36 := 
      --  "000000000000000000000111101010000101";
		constant DIVISOR: sfixed36 := to_sfixed(-0.0149558, sfixed36'high, sfixed36'low);

    
    constant reciprocal_DIVISOR : sfixed36 := 
        resize(
            reciprocal(DIVISOR), 
            sfixed36'high, 
            sfixed36'low,
            fixed_overflow_style,  -- Lowercase enumeration
            fixed_round_style       -- Lowercase enumeration
        );
begin
    output <= resize(
        input * reciprocal_DIVISOR,
        sfixed36'high,
        sfixed36'low,
        fixed_overflow_style,
        fixed_round_style
    );
end behav;