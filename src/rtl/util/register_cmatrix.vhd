library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity register_cmatrix is
    Port (
        clk      : in std_logic;
        reset    : in std_logic;
        load     : in std_logic;
        data_in  : in cmatrix;
        data_out : out cmatrix
    );
end register_cmatrix;

architecture Behavioral of register_cmatrix is
    signal register_value : cmatrix;
begin

    process(clk, reset)
    begin
        if reset = '1' then
            -- Reset: set every element in the matrix to zero.
            register_value <= (others => (others => (re => (others => '0'),
                                                      im => (others => '0'))));
        elsif rising_edge(clk) then
            if load = '1' then
                register_value <= data_in;
            end if;
        end if;
    end process;

    data_out <= register_value;

end Behavioral;
