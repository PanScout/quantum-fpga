library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Register_cmatrixHigh is
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        load     : in  std_logic;
        data_in  : in  cmatrixHigh;
        data_out : out cmatrixHigh
    );
end Register_cmatrixHigh;

architecture Behavioral of Register_cmatrixHigh is
    -- Internal register signal
    signal register_value : cmatrixHigh;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            -- On reset, clear the register.
            -- Each element of the matrix is set to zero.
            register_value <= (others => (others => (re => "0000000000000000000000000000000000000000000000000000000000000000",
                                                      im => "0000000000000000000000000000000000000000000000000000000000000000")));
        elsif rising_edge(clk) then
            if load = '1' then
                register_value <= data_in;
            end if;
        end if;
    end process;

    -- Drive the output with the current register value.
    data_out <= register_value;

end Behavioral;

