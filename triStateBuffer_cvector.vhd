library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity TristateBuffer_cvector is
    Port (
        data_in : in  cvector;
        enable  : in  std_logic;
        data_out: out cvector
    );
end TristateBuffer_cvector;

architecture Behavioral of TristateBuffer_cvector is
    -- Define a default value for the cvector.
    -- Since we cannot drive 'Z' for a composite type,
    -- we use zeros to represent a "disabled" state.
    constant default_cvector : cvector := 
      (others => (re => to_sfixed(0, fixed'high, fixed'low),
                  im => to_sfixed(0, fixed'high, fixed'low)));
begin

    -- Multiplexer: when enable = '1', pass through data_in; otherwise, drive zeros.
    data_out <= data_in when enable = '1' else default_cvector;

end Behavioral;

