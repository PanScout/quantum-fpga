library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity triStateBuffer_cMatrixHigh is
    Port (
        clk          : in  std_logic;
        rst          : in  std_logic;
        delay_cycles : in  natural;  -- Number of clock cycles to wait
        data_in      : in  cmatrixHigh;
        data_out     : out cmatrixHigh
    );
end triStateBuffer_cMatrixHigh;

architecture Behavioral of triStateBuffer_cMatrixHigh is
    signal counter     : natural := 0;
    signal output_valid: std_logic := '0';
    
    -- A default value used while the output is "disabled."
    constant default_val : cmatrixHigh :=
      (others => (others => (
           re => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
           im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
      )));
begin

    process(clk, rst)
    begin
        if rst = '1' then
            counter      <= 0;
            output_valid <= '0';
        elsif rising_edge(clk) then
            if counter < delay_cycles then
                counter <= counter + 1;
                output_valid <= '0';
            else
                output_valid <= '1';
            end if;
        end if;
    end process;
    
    -- While output is not yet enabled, drive a default value.
    -- Once enabled, data_out follows data_in.
    data_out <= data_in when output_valid = '1' else default_val;

end Behavioral;

