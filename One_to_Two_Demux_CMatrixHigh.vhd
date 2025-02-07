library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity One_to_Two_Demux_CMatrixHigh is
    Port (
        data_in : in  cmatrixHigh;
        sel     : in  std_logic;
        out0    : out cmatrixHigh;
        out1    : out cmatrixHigh
    );
end One_to_Two_Demux_CMatrixHigh;

architecture Behavioral of One_to_Two_Demux_CMatrixHigh is
    -- Define a constant zero matrix (all elements zero)
    constant ZERO_MATRIX : cmatrixHigh := (
        others => (others => (re => to_sfixed(0, fixedHigh'high, fixedHigh'low),
                              im => to_sfixed(0, fixedHigh'high, fixedHigh'low)))
    );
begin
    -- If sel = '0', drive out0 with data_in and out1 with zeros.
    -- If sel = '1', drive out1 with data_in and out0 with zeros.
    out0 <= data_in when sel = '0' else ZERO_MATRIX;
    out1 <= data_in when sel = '1' else ZERO_MATRIX;
end Behavioral;
