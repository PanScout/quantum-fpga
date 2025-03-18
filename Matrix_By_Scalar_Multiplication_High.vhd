library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.sfixed.ALL;

entity Matrix_By_Scalar_Multiplication_High is
    Port (
        A      : in  cmatrixHigh;    -- Input matrix
        scalar : in  cfixedHigh;     -- Scalar to multiply
        C      : out cmatrixHigh     -- Output matrix (A * scalar)
    );
end Matrix_By_Scalar_Multiplication_High;

architecture Concurrent of Matrix_By_Scalar_Multiplication_High is
begin
    -- Generate multipliers for each matrix element
    gen_row_mult : for row_idx in 0 to numBasisStates-1 generate
        gen_col_mult : for col_idx in 0 to numBasisStates-1 generate
        begin
            -- Complex multiplication implementation
            -- Real part: (A.re * scalar.re) - (A.im * scalar.im)
            C(row_idx)(col_idx).re <= resize(
                A(row_idx)(col_idx).re * scalar.re - 
                A(row_idx)(col_idx).im * scalar.im, fixedHigh'high, fixedHigh'low
            );
            
            -- Imaginary part: (A.re * scalar.im) + (A.im * scalar.re)
            C(row_idx)(col_idx).im <= resize(
                A(row_idx)(col_idx).re * scalar.im + 
                A(row_idx)(col_idx).im * scalar.re, fixedHigh'high, fixedHigh'low
            );
        end generate gen_col_mult;
    end generate gen_row_mult;
end architecture Concurrent;
