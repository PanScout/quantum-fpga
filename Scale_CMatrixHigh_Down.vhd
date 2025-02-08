library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Scale_CMatrixHigh_Down is
port (
    Input_Matrix  : in  cmatrixHigh;
    Shift_Amount  : in  fixedHigh; -- Integer shift value (absolute value used)
    Output_Matrix : out cmatrixHigh
);
end Scale_CMatrixHigh_Down;

architecture Structural of Scale_CMatrixHigh_Down is
    constant MAX_SHIFT_BITS : integer := 64;
    
    -- Convert shift amount to unsigned integer
    signal shift_mag : natural := 0;
begin
    -- Convert fixed-point shift amount to natural number
    shift_mag <= abs(to_integer(Shift_Amount));

    -- Generate scaling logic for matrix elements
    row_gen: for i in 0 to numBasisStates-1 generate
        col_gen: for j in 0 to numBasisStates-1 generate
            -- Real component scaling
            Output_Matrix(i)(j).re <= 
                shift_right(Input_Matrix(i)(j).re, shift_mag);
            
            -- Imaginary component scaling
            Output_Matrix(i)(j).im <= 
                shift_right(Input_Matrix(i)(j).im, shift_mag);
        end generate col_gen;
    end generate row_gen;
end Structural;