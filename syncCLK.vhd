library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clk_gen is
  Port (
    clk_in  : in  STD_LOGIC;   -- System clock (100 MHz)
    clk_out : out STD_LOGIC     -- Generated clock (10 MHz)
  );
end clk_gen;

architecture Behavioral of clk_gen is
  signal counter : integer := 0;
  signal clk_div : STD_LOGIC := '0';
begin
  process(clk_in)
  begin
    if rising_edge(clk_in) then
      if counter = 4 then  -- 100 MHz / (5*2) = 10 MHz
        clk_div <= not clk_div;
        counter <= 0;
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;
  clk_out <= clk_div;
end Behavioral;
