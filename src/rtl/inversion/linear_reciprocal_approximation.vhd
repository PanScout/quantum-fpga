library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;


entity linear_reciprocal_approximation is
    Port ( 
        x : in sfixed36;   -- Input signal (64-bit)
        y : out sfixed36   -- Output signal (64-bit)
    );
end linear_reciprocal_approximation;

architecture Behavioral of linear_reciprocal_approximation is
    -- Define constants a and b (64-bit)
    --constant a : sfixed64 := b"1111111111111111111111111111111111111111111010110111000100010011"; -- Example value
    --constant a : sfixed64 := b"1111111111111111111111111111111111111111111111101011011100001011"; -- Example value
    --constant b : sfixed64 := b"0000000000000000000000000000100100010001011110101000000111100101";   -- Example value
    --constant b : sfixed64 := b"0000000000000000000000000000000010010001000110001111000011110111";
	 
	     -- Linear‐regression coefficients for 1/x over [14400.0 : 14508.0]
    constant a : sfixed64 := 
        to_sfixed(-4.786935579730009e-9, sfixed64'high, sfixed64'low);
    constant b : sfixed64 := 
        to_sfixed( 0.0001383756893529524,  sfixed64'high, sfixed64'low);
		  
		  
    -- Declare intermediate signals with the same 64-bit precision
    signal mult_result : sfixed36;
    signal x_64bit   : sfixed64;
    signal result_64 : sfixed64;
    
begin

    x_64bit <= to_64bit(x);

    -- Step 1: Calculate a*x and immediately resize to maintain 64-bit format
    --mult_result <= resize(a * x, sfixed36'high, sfixed36'low);
    result_64 <= resize(a * x_64bit + b, sfixed64'high, sfixed64'low);
    
    -- Step 2: Add b to a*x and maintain 64-bit format with final resize
    --y <= resize(mult_result + b, sfixed36'high, sfixed36'low);

    y <= from_64bit(resize(result_64, sfixed64'high, sfixed64'low));
    
end Behavioral;