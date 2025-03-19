library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Multiply_Column_By_Scalar_High is
    Port (
        constComplex : in  cfixedHigh;   -- ?? High-precision complex scalar
        rowVector    : in  cvectorHigh;  -- ?? High-precision input vector
        outputVector : out cvectorHigh   -- ?? High-precision output vector
    );
end Multiply_Column_By_Scalar_High;

architecture Behavioral of Multiply_Column_By_Scalar_High is
    -- ?? High-precision range constants
    constant PROD_HIGH : integer := fixedHigh'high + fixedHigh'high + 1;  -- ?? Extra safety bit
    constant PROD_LOW  : integer := fixedHigh'low + fixedHigh'low;         -- ?? Maintain precision
begin

    -- ?? Generate high-precision complex multiplications
    gen_multiply: for i in 0 to numBasisStates - 1 generate
    begin
        -- Real part: (a.re * b.re) - (a.im * b.im) ??
        outputVector(i).re <= resize(
            resize(constComplex.re * rowVector(i).re, PROD_HIGH, PROD_LOW) - 
            resize(constComplex.im * rowVector(i).im, PROD_HIGH, PROD_LOW),
            fixedHigh'high, fixedHigh'low  -- ?? Final resize to high-precision output
        );
        
        -- Imaginary part: (a.re * b.im) + (a.im * b.re) ??
        outputVector(i).im <= resize(
            resize(constComplex.re * rowVector(i).im, PROD_HIGH, PROD_LOW) + 
            resize(constComplex.im * rowVector(i).re, PROD_HIGH, PROD_LOW),
            fixedHigh'high, fixedHigh'low  -- ?? Final resize to high-precision output
        );
    end generate gen_multiply;

end Behavioral;
