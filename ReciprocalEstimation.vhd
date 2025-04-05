library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;


entity ReciprocalEstimation is
    Port ( 
        x : in fixed64;   -- Input signal (64-bit)
        y : out fixed64   -- Output signal (64-bit)
    );
end ReciprocalEstimation;

architecture Behavioral of ReciprocalEstimation is
    -- Define constants a and b (64-bit)
    constant a : fixed64_64 := b"1111111111111111111111111111111111111111111010110111000100010011"; -- Example value
    constant b : fixed64_64 := b"0000000000000000000000000000100100010001011110101000000111100101";   -- Example value
    
    -- Declare intermediate signals with the same 64-bit precision
    signal mult_result : fixed64;
    signal x_64bit   : fixed64_64;
    signal result_64 : fixed64_64;
    
begin

    x_64bit <= to_64bit(x);

    -- Step 1: Calculate a*x and immediately resize to maintain 64-bit format
    --mult_result <= resize(a * x, fixed64'high, fixed64'low);
    result_64 <= resize(a * x_64bit + b, fixed64_64'high, fixed64_64'low);
    
    -- Step 2: Add b to a*x and maintain 64-bit format with final resize
    --y <= resize(mult_result + b, fixed64'high, fixed64'low);

    y <= from_64bit(resize(result_64, fixed64_64'high, fixed64_64'low));
    
end Behavioral;