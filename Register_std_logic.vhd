library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_std_logic is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        load  : in  std_logic;
        d     : in  std_logic;
        q     : out std_logic
    );
end Register_std_logic;

architecture Behavioral of Register_std_logic is
    signal q_reg : std_logic;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q_reg <= '0';
        elsif rising_edge(clk) then
            if load = '1' then
                q_reg <= d;
            end if;
        end if;
    end process;
    
    q <= q_reg;
end Behavioral;

