library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;

entity TriStateBuffer_std_logic is
    Port(
        clk        : in  std_logic;
        rst        : in  std_logic;
        out_signal : out std_logic
    );
end TriStateBuffer_std_logic;

architecture Behavioral of TriStateBuffer_std_logic is
    signal counter : natural := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            counter    <= 0;
            out_signal <= '0';
        elsif rising_edge(clk) then
            if counter < 20 then
                counter    <= counter + 1;
                out_signal <= '0';
            else
                out_signal <= '1';
            end if;
        end if;
    end process;
end Behavioral;

