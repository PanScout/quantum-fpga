library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_std_logic is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        d     : in  std_logic;
        q     : out std_logic
    );
end Register_std_logic;

architecture Behavioral of Register_std_logic is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= '0';
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end Behavioral;

