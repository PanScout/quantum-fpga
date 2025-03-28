library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity TristateBuffer_cvector is
    Port (
        data_in : in  cvector;
        enable  : in  std_logic;
        data_out: out cvector
    );
end TristateBuffer_cvector;

architecture Behavioral of TristateBuffer_cvector is
    -- Define a default value for the cvector using "others" to fill zeros
    constant default_cvector : cvector := 
      (others => (re => (others => '0'),
                  im => (others => '0')));
begin

    -- Multiplexer: when enable = '1', pass through data_in; otherwise, drive zeros.
    data_out <= data_in when enable = '1' else default_cvector;

end Behavioral;
