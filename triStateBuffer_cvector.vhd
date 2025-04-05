library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity TristateBuffer_cvector is
    Port (
        data_in  : in  cvector;
        enable   : in  std_logic;
        data_out : out cvector
    );
end TristateBuffer_cvector;

architecture Behavioral of TristateBuffer_cvector is
    -- Define a default complex constant
    constant default_complex : cfixed64 := (re => (others => '0'), im => (others => '0'));
    -- Use the default complex to fill the entire cvector
    constant default_cvector : cvector := (others => default_complex);
begin
    -- When enable is '1', pass data_in; otherwise, drive zeros.
    data_out <= data_in when enable = '1' else default_cvector;
end Behavioral;
