library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Register_cvector is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        load     : in  std_logic;
        data_in  : in  cvector;
        data_out : out cvector
    );
end Register_cvector;

architecture Behavioral of Register_cvector is
    signal register_value : cvector;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset: initialize each element to zero.
            register_value <= (others => (re => "0000000000000000000000000",
                                          im => "0000000000000000000000000"));
        elsif rising_edge(clk) then
            if load = '1' then
                register_value <= data_in;
            end if;
        end if;
    end process;

    data_out <= register_value;

end Behavioral;
