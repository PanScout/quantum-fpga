library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.all;

entity Norm_Theta_Ratio is
    Port (
        input  : in  fixedHigh;
        output : out fixedHigh
    );
end Norm_Theta_Ratio;

architecture behav of Norm_Theta_Ratio is
    constant DIVISOR : fixedHigh := 
        "0000000000000000000011110101000010010110001111111111101100000000";
    
    constant reciprocal_DIVISOR : fixedHigh := 
        resize(
            reciprocal(DIVISOR), 
            fixedHigh'high, 
            fixedHigh'low,
            fixed_overflow_style,  -- Lowercase enumeration
            fixed_round_style       -- Lowercase enumeration
        );
begin
    output <= resize(
        input * reciprocal_DIVISOR,
        fixedHigh'high,
        fixedHigh'low,
        fixed_overflow_style,
        fixed_round_style
    );
end behav;