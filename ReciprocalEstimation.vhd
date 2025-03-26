library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;


entity ReciprocalEstimation is
    Port ( 
        x : in fixedHigh;   -- Input signal (64-bit)
        y : out fixedHigh   -- Output signal (64-bit)
    );
end ReciprocalEstimation;

architecture Behavioral of ReciprocalEstimation is
    -- Define constants a and b (64-bit)
    constant a : fixedHigh := b"1111111111111111111111111111111111111111111010110111000100010011"; -- Example value
    constant b : fixedHigh := b"0000000000000000000000000000100100010001011110101000000111100101";   -- Example value
    
    -- Declare intermediate signals with the same 64-bit precision
    signal mult_result : fixedHigh;
    
begin
    -- Step 1: Calculate a*x and immediately resize to maintain 64-bit format
    mult_result <= resize(a * x, fixedHigh'high, fixedHigh'low);
    
    -- Step 2: Add b to a*x and maintain 64-bit format with final resize
    y <= resize(mult_result + b, fixedHigh'high, fixedHigh'low);
    
end Behavioral;