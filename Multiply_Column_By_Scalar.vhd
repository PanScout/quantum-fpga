library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Multiply_Column_By_Scalar is
    Port (
        constComplex : in  cfixed64;   -- ?? High-precision complex scalar
        rowVector    : in  cvector;  -- ?? High-precision input vector
        outputVector : out cvector   -- ?? High-precision output vector
    );
end Multiply_Column_By_Scalar;

architecture Behavioral of Multiply_Column_By_Scalar is
    -- ?? High-precision range constants
    constant PROD_HIGH : integer := fixed64'high + fixed64'high + 1;  -- ?? Extra safety bit
    constant PROD_LOW  : integer := fixed64'low + fixed64'low;         -- ?? Maintain precision
begin

    -- ?? Generate high-precision complex multiplications
    gen_multiply: for i in 0 to dimension - 1 generate
    begin
        -- Real part: (a.re * b.re) - (a.im * b.im) ??
        outputVector(i).re <= resize(
            resize(constComplex.re * rowVector(i).re, PROD_HIGH, PROD_LOW) - 
            resize(constComplex.im * rowVector(i).im, PROD_HIGH, PROD_LOW),
            fixed64'high, fixed64'low  -- ?? Final resize to high-precision output
        );
        
        -- Imaginary part: (a.re * b.im) + (a.im * b.re) ??
        outputVector(i).im <= resize(
            resize(constComplex.re * rowVector(i).im, PROD_HIGH, PROD_LOW) + 
            resize(constComplex.im * rowVector(i).re, PROD_HIGH, PROD_LOW),
            fixed64'high, fixed64'low  -- ?? Final resize to high-precision output
        );
    end generate gen_multiply;

end Behavioral;
