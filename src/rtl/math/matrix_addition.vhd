library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity matrix_addition is
    Port (
        A : in  cmatrix;    -- First input matrix
        B : in  cmatrix;    -- Second input matrix
        C : out cmatrix     -- Output matrix (A + B)
    );
end matrix_addition;

architecture Concurrent of matrix_addition is
begin
    -- Generate adders for each matrix element
    gen_row_adders : for row_idx in 0 to dimension-1 generate
        gen_col_adders : for col_idx in 0 to dimension-1 generate
        begin
            -- Add real components
            C(row_idx)(col_idx).re <= resize(A(row_idx)(col_idx).re + B(row_idx)(col_idx).re, sfixed36'high, sfixed36'low);
            
            -- Add imaginary components
            C(row_idx)(col_idx).im <= resize(A(row_idx)(col_idx).im + B(row_idx)(col_idx).im, sfixed36'high, sfixed36'low);
        end generate gen_col_adders;
    end generate gen_row_adders;
end architecture Concurrent;
