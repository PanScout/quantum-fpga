library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Multiply_Column_By_Scalar is
    Port (
        constComplex : in  cfixed;      -- ?? Input complex scalar
        rowVector    : in  cvector;     -- ?? Input complex vector
        outputVector : out cvector      -- ?? Output complex vector
    );
end Multiply_Column_By_Scalar;

architecture Behavioral of Multiply_Column_By_Scalar is
    -- ?? Constants for range management
    constant PROD_HIGH : integer := fixed'high + fixed'high + 1;  -- ?? Extra bit for safety
    constant PROD_LOW  : integer := fixed'low + fixed'low;         -- ?? Maintain precision
begin

    -- ?? Generate complex multiplications
    gen_multiply: for i in 0 to numBasisStates - 1 generate
    begin
        -- Real part: (a.re * b.re) - (a.im * b.im) ??
        outputVector(i).re <= resize(
            resize(constComplex.re * rowVector(i).re, PROD_HIGH, PROD_LOW) - 
            resize(constComplex.im * rowVector(i).im, PROD_HIGH, PROD_LOW),
            fixed'high, fixed'low  -- ?? Final resize to output range
        );
        
        -- Imaginary part: (a.re * b.im) + (a.im * b.re) ??
        outputVector(i).im <= resize(
            resize(constComplex.re * rowVector(i).im, PROD_HIGH, PROD_LOW) + 
            resize(constComplex.im * rowVector(i).re, PROD_HIGH, PROD_LOW),
            fixed'high, fixed'low  -- ?? Final resize to output range
        );
    end generate gen_multiply;

end Behavioral;
