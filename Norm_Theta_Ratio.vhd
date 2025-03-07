library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed.ALL;
use work.qTypes.all;

entity Norm_Theta_Ratio is
    Port (
        input  : in  fixedHigh;
        output : out fixedHigh
    );
end Norm_Theta_Ratio;

architecture behav of Norm_Theta_Ratio is
    -- Example: divide by 4.0 (modify this constant as needed)
    constant DIVISOR : fixedHigh := 
        to_sfixed(2.1, fixedHigh'high, fixedHigh'low);
begin
    -- Concurrent division with proper resizing
    output <= resize(input / DIVISOR, fixedHigh'high, fixedHigh'low);
end behav;
