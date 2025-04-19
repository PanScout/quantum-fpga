library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    generic (
        -- Adjust this constant to change the division factor
        DIVISOR : natural := 10000000
    );
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic
    );
end entity clock_divider;

architecture rtl of clock_divider is
    -- Counter range depends on DIVISOR
    signal counter : natural range 0 to DIVISOR-1 := 0;
    signal clk_reg : std_logic := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if counter = DIVISOR-1 then
                counter <= 0;
                clk_reg <= not clk_reg;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    clk_out <= clk_reg;
end architecture rtl;
