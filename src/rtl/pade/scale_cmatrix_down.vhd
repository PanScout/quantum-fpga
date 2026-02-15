library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity scale_cmatrix_down is
port (
    Input_Matrix  : in  cmatrix;
    Shift_Amount  : in  csfixed36; -- Integer shift value (absolute value used)
    Output_Matrix : out cmatrix
);
end scale_cmatrix_down;

architecture Structural of scale_cmatrix_down is
    constant MAX_SHIFT_BITS : integer := 64;
    
    -- Convert shift amount to unsigned integer
    signal shift_mag : natural := 0;
begin
    -- Convert sfixed36-point shift amount to natural number
    shift_mag <= abs(to_integer(Shift_Amount.re));
    --shift_mag <= to_natural(Shift_Amount.re);

    -- Generate scaling logic for matrix elements
    row_gen: for i in 0 to dimension-1 generate
        col_gen: for j in 0 to dimension-1 generate
            -- Real component scaling
            Output_Matrix(i)(j).re <= 
                shift_right(Input_Matrix(i)(j).re, shift_mag);
            
            -- Imaginary component scaling
            Output_Matrix(i)(j).im <= 
                shift_right(Input_Matrix(i)(j).im, shift_mag);
        end generate col_gen;
    end generate row_gen;
end Structural;
