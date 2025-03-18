library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL; 
use work.qTypes.ALL;  -- Import the qTypes package
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

-- Entity Declaration
entity Complex_ALU_High is
    Port (
        -- Inputs: Complex Number A and B
        A       : in  cfixedHigh;
        B       : in  cfixedHigh;
        
        Op      : in  std_logic_vector(1 downto 0);
      
        -- Output: Resultant Complex Number
        Result  : out cfixedHigh
    );
end Complex_ALU_High;

-- Architecture Definition
architecture Behavioral of Complex_ALU_High is

    -- Keep only this signal for division
    signal div_denom : fixedHigh;

begin

    -- Compute denominator for division
    div_denom <= resize((B.re * B.re) + (B.im * B.im), fixedHigh'high, fixedHigh'low);

    -- Real Part Assignment
    with Op select
        Result.re <= 
            -- ADD
            resize(A.re + B.re, fixedHigh'high, fixedHigh'low) when "00",
            -- SUB
            resize(A.re - B.re, fixedHigh'high, fixedHigh'low) when "01",
            -- MUL: (A.re * B.re) - (A.im * B.im)
            resize((A.re * B.re) - (A.im * B.im), fixedHigh'high, fixedHigh'low) when "10",
            -- DIV: (A.re * B.re + A.im * B.im) / (B.re^2 + B.im^2)
            resize(
                resize((A.re * B.re) + (A.im * B.im), fixedHigh'high, fixedHigh'low)
                / div_denom, 
                fixedHigh'high, fixedHigh'low
            ) when "11",
            -- DEFAULT
            (others => '0') when others;

    -- Imaginary Part Assignment
    with Op select
        Result.im <=
            -- ADD
            resize(A.im + B.im, fixedHigh'high, fixedHigh'low) when "00",
            -- SUB
            resize(A.im - B.im, fixedHigh'high, fixedHigh'low) when "01",
            -- MUL: (A.re * B.im) + (A.im * B.re)
            resize((A.re * B.im) + (A.im * B.re), fixedHigh'high, fixedHigh'low) when "10",
            -- DIV: (A.im * B.re - A.re * B.im) / (B.re^2 + B.im^2)
            resize(
                resize((A.im * B.re) - (A.re * B.im), fixedHigh'high, fixedHigh'low)
                / div_denom, 
                fixedHigh'high, fixedHigh'low
            ) when "11",
            -- DEFAULT
            (others => '0') when others;

end Behavioral;

