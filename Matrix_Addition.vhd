library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Matrix_Addition is
    Port (
        A : in  cmatrix;    -- First input matrix
        B : in  cmatrix;    -- Second input matrix
        C : out cmatrix     -- Output matrix (A + B)
    );
end Matrix_Addition;

architecture Concurrent of Matrix_Addition is
begin
    -- Generate adders for each matrix element
    gen_row_adders : for row_idx in 0 to dimension-1 generate
        gen_col_adders : for col_idx in 0 to dimension-1 generate
        begin
            -- Add real components
            C(row_idx)(col_idx).re <= resize(A(row_idx)(col_idx).re + B(row_idx)(col_idx).re, fixed64'high, fixed64'low);
            
            -- Add imaginary components
            C(row_idx)(col_idx).im <= resize(A(row_idx)(col_idx).im + B(row_idx)(col_idx).im, fixed64'high, fixed64'low);
        end generate gen_col_adders;
    end generate gen_row_adders;
end architecture Concurrent;
