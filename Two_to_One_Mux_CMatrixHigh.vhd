library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed.ALL;
use work.qTypes.all;

-- Two-input, one-output multiplexer for complex matrices
entity Two_to_One_Mux_CMatrixHigh is
    Port (
        in0      : in  cmatrixHigh;  -- Input 0
        in1      : in  cmatrixHigh;  -- Input 1
        sel      : in  std_logic;    -- Selector
        data_out : out cmatrixHigh   -- Output
    );
end Two_to_One_Mux_CMatrixHigh;

architecture Behavioral of Two_to_One_Mux_CMatrixHigh is
begin
    -- Route in0 to data_out if sel = '0', else route in1
    data_out <= in0 when sel = '0' else in1;
end Behavioral;
