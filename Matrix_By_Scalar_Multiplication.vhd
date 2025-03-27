library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed64.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity Matrix_By_Scalar_Multiplication is
    Port (
        A      : in  cmatrix;    -- Input matrix
        scalar : in  cfixed64;     -- Scalar to multiply
        C      : out cmatrix     -- Output matrix (A * scalar)
    );
end Matrix_By_Scalar_Multiplication;

architecture Concurrent of Matrix_By_Scalar_Multiplication is
begin
    -- Generate multipliers for each matrix element
    gen_row_mult : for row_idx in 0 to dimension-1 generate
        gen_col_mult : for col_idx in 0 to dimension-1 generate
        begin
            -- Complex multiplication implementation
            -- Real part: (A.re * scalar.re) - (A.im * scalar.im)
            C(row_idx)(col_idx).re <= resize(
                A(row_idx)(col_idx).re * scalar.re - 
                A(row_idx)(col_idx).im * scalar.im, fixed64'high, fixed64'low
            );
            
            -- Imaginary part: (A.re * scalar.im) + (A.im * scalar.re)
            C(row_idx)(col_idx).im <= resize(
                A(row_idx)(col_idx).re * scalar.im + 
                A(row_idx)(col_idx).im * scalar.re, fixed64'high, fixed64'low
            );
        end generate gen_col_mult;
    end generate gen_row_mult;
end architecture Concurrent;
