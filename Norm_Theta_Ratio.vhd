library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.all;

entity Norm_Theta_Ratio is
    Port (
        input  : in  fixed64;
        output : out fixed64
    );
end Norm_Theta_Ratio;

architecture behav of Norm_Theta_Ratio is
    constant DIVISOR : fixed64 := 
        "0000000000000000000000111101010000100101100011111111111011000000";
    
    constant reciprocal_DIVISOR : fixed64 := 
        resize(
            reciprocal(DIVISOR), 
            fixed64'high, 
            fixed64'low,
            fixed_overflow_style,  -- Lowercase enumeration
            fixed_round_style       -- Lowercase enumeration
        );
begin
    output <= resize(
        input * reciprocal_DIVISOR,
        fixed64'high,
        fixed64'low,
        fixed_overflow_style,
        fixed_round_style
    );
end behav;