
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL;
--use IEEE.fixed_pkg.ALL;
use work.sfixed.ALL;
use work.qTypes.ALL;  -- Import the qTypes package

-- Entity Declaration
entity Complex_ALU is
    Port (
        -- Inputs: Complex Number A and B
        A       : in  cfixed;
        B       : in  cfixed;
        
        Op      : in  std_logic_vector(1 downto 0);
      
        -- Output: Resultant Complex Number
        Result  : out cfixed
    );
end Complex_ALU;

-- Architecture Definition
architecture Behavioral of Complex_ALU is

    -- Keep only this signal for division
    signal div_denom : fixed;

begin

    -- Compute denominator for division
    div_denom <= resize((B.re * B.re) + (B.im * B.im), fixed'high, fixed'low);

    -- Real Part Assignment
    with Op select
        Result.re <= 
            -- ADD
            resize(A.re + B.re, fixed'high, fixed'low) when "00",
            -- SUB
            resize(A.re - B.re, fixed'high, fixed'low) when "01",
            -- MUL: (A.re * B.re) - (A.im * B.im)
            resize((A.re * B.re) - (A.im * B.im), fixed'high, fixed'low) when "10",
            -- DIV: (A.re * B.re + A.im * B.im) / (B.re^2 + B.im^2)
            resize(
                resize((A.re * B.re) + (A.im * B.im), fixed'high, fixed'low)
                / div_denom, 
                fixed'high, fixed'low
            ) when "11",
            -- DEFAULT
            (others => '0') when others;

    -- Imaginary Part Assignment
    with Op select
        Result.im <=
            -- ADD
            resize(A.im + B.im, fixed'high, fixed'low) when "00",
            -- SUB
            resize(A.im - B.im, fixed'high, fixed'low) when "01",
            -- MUL: (A.re * B.im) + (A.im * B.re)
            resize((A.re * B.im) + (A.im * B.re), fixed'high, fixed'low) when "10",
            -- DIV: (A.im * B.re - A.re * B.im) / (B.re^2 + B.im^2)
            resize(
                resize((A.im * B.re) - (A.re * B.im), fixed'high, fixed'low)
                / div_denom, 
                fixed'high, fixed'low
            ) when "11",
            -- DEFAULT
            (others => '0') when others;

end Behavioral;

