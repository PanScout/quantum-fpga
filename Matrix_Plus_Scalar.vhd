library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed64.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

use work.qTypes.all;

entity Matrix_Plus_Scalar is
    port (
        input_cMatrixH : in cmatrix;
        scalar         : in cfixed64;
        output_cMatrixH : out cmatrix
    );
end Matrix_Plus_Scalar;

architecture Structural of Matrix_Plus_Scalar is

begin
    -- Generate matrix elements using nested generate statements
    gen_rows: for i in 0 to dimension-1 generate
        gen_cols: for j in 0 to dimension-1 generate
            -- Diagonal elements: input + scalar
            -- Off-diagonal elements: pass through input
            output_cMatrixH(i)(j).re <= 
                resize(input_cMatrixH(i)(j).re + scalar.re, fixed64'high, fixed64'low) 
                when (i = j) else 
                input_cMatrixH(i)(j).re;
            
            output_cMatrixH(i)(j).im <= 
                resize(input_cMatrixH(i)(j).im + scalar.im, fixed64'high, fixed64'low) 
                when (i = j) else 
                input_cMatrixH(i)(j).im;
        end generate gen_cols;
    end generate gen_rows;

end Structural;
