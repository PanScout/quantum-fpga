library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity normThetaRatio is
    Port (
        input  : in  fixedHigh;
        output : out fixedHigh
    );
end normThetaRatio;

architecture behav of normThetaRatio is
    -- Example: divide by 4.0 (modify this constant as needed)
    constant DIVISOR : fixedHigh := 
        to_sfixed(2.1, fixedHigh'high, fixedHigh'low);
begin
    -- Concurrent division with proper resizing
    output <= resize(input / DIVISOR, fixedHigh'high, fixedHigh'low);
end behav;
