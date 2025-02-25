library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Register_cfixed is
    Port (
        clk   : in std_logic;
        reset : in std_logic;
        load  : in std_logic;
        d     : in cfixed;
        q     : out cfixed
    );
end Register_cfixed;

architecture Behavioral of Register_cfixed is
    signal q_reg : cfixed;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q_reg <= (re => to_sfixed(0, fixed'high, fixed'low),
                      im => to_sfixed(0, fixed'high, fixed'low));
        elsif rising_edge(clk) then
            if load = '1' then
                q_reg <= d;
            end if;
        end if;
    end process;
    
    q <= q_reg;
end Behavioral;

