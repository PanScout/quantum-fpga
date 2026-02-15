library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Register_cmatrix is
    Port (
        clk      : in std_logic;
        rst      : in std_logic;
        load     : in std_logic;
        data_in  : in cmatrix;
        data_out : out cmatrix
    );
end Register_cmatrix;

architecture Behavioral of Register_cmatrix is
    signal register_value : cmatrix;
begin

    process(clk, rst)
    begin
        if rst = '1' then
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
