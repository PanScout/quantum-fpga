library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.all;
--use work.sfixed36.ALL;
use work.fixed_pkg.ALL;

entity matrix_transpose is
    Port (
        input_matrix  : in  cmatrix;
        output_matrix : out cmatrix
    );
end matrix_transpose;

architecture Concurrent of matrix_transpose is
begin
    -- Generate statement creates parallel transpose connections
    gen_transpose: for i in 0 to dimension-1 generate
        gen_row: for j in 0 to dimension-1 generate
            -- Direct connection with swapped indices
            output_matrix(i)(j).re <= input_matrix(j)(i).re;
            output_matrix(i)(j).im <= input_matrix(j)(i).im;
        end generate gen_row;
    end generate gen_transpose;
end architecture Concurrent;
