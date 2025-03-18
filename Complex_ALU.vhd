library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Complex_ALU is
    Port (
        A       : in  cfixed;    -- ?? Input complex number A
        B       : in  cfixed;    -- ?? Input complex number B
        Op      : in  std_logic_vector(1 downto 0);  -- ??? Operation selector
        Result  : out cfixed     -- ?? Output result
    );
end Complex_ALU;

architecture Behavioral of Complex_ALU is
    -- ?? Constants for multiplication range management
    constant MULT_HIGH : integer := fixed'high + fixed'high + 1;  -- ?? Extra headroom
    constant MULT_LOW  : integer := fixed'low + fixed'low;        -- ?? Precision keeper
    
    signal div_denom     : sfixed(fixed'high downto fixed'low);    -- ?? Division denominator
    signal bre_squared   : sfixed(MULT_HIGH downto MULT_LOW);     -- ?? B.re squared
    signal bim_squared   : sfixed(MULT_HIGH downto MULT_LOW);     -- ?? B.im squared
    
begin
    -- ?? Denominator calculation pipeline
    bre_squared <= resize(B.re * B.re, MULT_HIGH, MULT_LOW);  -- ??? Build B.re²
    bim_squared <= resize(B.im * B.im, MULT_HIGH, MULT_LOW);  -- ??? Build B.im²
    div_denom <= resize(bre_squared + bim_squared, fixed'high, fixed'low);  -- ?? Final denominator

    -- Real Part Operations ??
    with Op select
        Result.re <= 
            -- ? Addition
            resize(A.re + B.re, Result.re) when "00",
            -- ? Subtraction
            resize(A.re - B.re, Result.re) when "01",
            -- ?? Multiplication (Real part)
            resize(
                resize(A.re * B.re, MULT_HIGH, MULT_LOW) - 
                resize(A.im * B.im, MULT_HIGH, MULT_LOW),  -- ?? Range-aligned subtraction
                Result.re
            ) when "10",
            -- ? Division (Real part)
            resize(
                (resize(A.re * B.re + A.im * B.im, MULT_HIGH, MULT_LOW)) / div_denom,
                Result.re
            ) when "11",
            -- ?? Default case
            (others => '0') when others;

    -- Imaginary Part Operations ??
    with Op select
        Result.im <=
            -- ? Addition
            resize(A.im + B.im, Result.im) when "00",
            -- ? Subtraction
            resize(A.im - B.im, Result.im) when "01",
            -- ?? Multiplication (Imaginary part)
            resize(
                resize(A.re * B.im, MULT_HIGH, MULT_LOW) + 
                resize(A.im * B.re, MULT_HIGH, MULT_LOW),  -- ?? Range-aligned addition
                Result.im
            ) when "10",
            -- ? Division (Imaginary part)
            resize(
                (resize(A.im * B.re - A.re * B.im, MULT_HIGH, MULT_LOW)) / div_denom,
                Result.im
            ) when "11",
            -- ?? Default case
            (others => '0') when others;

end Behavioral;
