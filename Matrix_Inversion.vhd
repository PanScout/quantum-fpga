 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Matrix_Inversion is
    Port (
        input_matrix  : in  cmatrixHigh;
        output_matrix : out cmatrixHigh
    );
end Matrix_Inversion;

architecture Behavioral of Matrix_Inversion is
begin

    -- TODO: Implement matrix inversion algorithm.
    -- This skeleton simply passes the input through to the output.
    output_matrix <= input_matrix;

end Behavioral;
