library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.sfixed.ALL;

entity TristateBuffer_cmatrix is
    Port (
        data_in : in  cmatrix;
        enable  : in  std_logic;
        data_out: out cmatrix
    );
end TristateBuffer_cmatrix;

architecture Behavioral of TristateBuffer_cmatrix is
    -- Define a default value for the cmatrix.
    -- Since we cannot drive 'Z' for a composite type,
    -- we use zeros to represent a "disabled" state.
    constant default_cmatrix : cmatrix := 
      (others => (others => (re => "0000000000000000000000000",
                              im => "0000000000000000000000000")));
begin

    -- Multiplexer: when enable = '1', pass through data_in; otherwise, drive zeros.
    data_out <= data_in when enable = '1' else default_cmatrix;

end Behavioral;

