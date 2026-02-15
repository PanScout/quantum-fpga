library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_std_logic is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        load  : in  std_logic;
        data_in  : in  std_logic;
        data_out : out std_logic
    );
end register_std_logic;

architecture Behavioral of register_std_logic is
    signal q_reg : std_logic;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q_reg <= '0';
        elsif rising_edge(clk) then
            if load = '1' then
                q_reg <= data_in;
            end if;
        end if;
    end process;
    
    data_out <= q_reg;
end Behavioral;

