library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.sfixed.ALL;
use work.qTypes.all;
--use IEEE.fixed_pkg.ALL;

entity Norm_Theta_Ratio is
    Port (
        input  : in  fixedHigh;
        output : out fixedHigh
    );
end Norm_Theta_Ratio;

architecture behav of Norm_Theta_Ratio is
    -- Example: divide by 4.0 (modify this constant as needed)
    constant DIVISOR : fixedHigh := 
        "0000000000000000000000000000000000000000000000000100001100110011001100110011001100110011001100110011010000000000000";
begin
    -- Concurrent division with proper resizing
    output <= resize(input / DIVISOR, fixedHigh'high, fixedHigh'low);
end behav;
