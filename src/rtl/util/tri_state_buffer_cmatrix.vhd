library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity tri_state_buffer_cmatrix is
    Port (
        data_in  : in  cmatrix;
        enable   : in  std_logic;
        data_out : out cmatrix
    );
end tri_state_buffer_cmatrix;

architecture Behavioral of tri_state_buffer_cmatrix is
    -- Define a default complex constant for type csfixed36.
    constant default_complex : csfixed36 := (re => (others => '0'), im => (others => '0'));
    -- Use the default complex to fill the entire cmatrix.
    constant default_cmatrix : cmatrix := (others => (others => default_complex));
begin
    -- Multiplexer: when enable = '1', pass through data_in; otherwise, drive zeros.
    data_out <= data_in when enable = '1' else default_cmatrix;
end Behavioral;
