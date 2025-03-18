library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL;
--use IEEE.fixed_pkg.ALL;
use work.sfixed.ALL;

use work.qTypes.all;

entity Matrix_Plus_Scalar_High is
    port (
        input_cMatrixH : in cmatrixHigh;
        scalar         : in cfixedHigh;
        output_cMatrixH : out cmatrixHigh
    );
end Matrix_Plus_Scalar_High;

architecture Structural of Matrix_Plus_Scalar_High is

begin
    -- Generate matrix elements using nested generate statements
    gen_rows: for i in 0 to numBasisStates-1 generate
        gen_cols: for j in 0 to numBasisStates-1 generate
            -- Diagonal elements: input + scalar
            -- Off-diagonal elements: pass through input
            output_cMatrixH(i)(j).re <= 
                resize(input_cMatrixH(i)(j).re + scalar.re, fixedHigh'high, fixedHigh'low) 
                when (i = j) else 
                input_cMatrixH(i)(j).re;
            
            output_cMatrixH(i)(j).im <= 
                resize(input_cMatrixH(i)(j).im + scalar.im, fixedHigh'high, fixedHigh'low) 
                when (i = j) else 
                input_cMatrixH(i)(j).im;
        end generate gen_cols;
    end generate gen_rows;

end Structural;
