library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.all;
use work.qTypes.all;

entity tb_padeDenominator is
end tb_padeDenominator;

architecture Behavioral of tb_padeDenominator is

    component padeDenominator
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            start : in  std_logic;
            B     : in  cmatrixHigh;
            P     : out cmatrixHigh;
            done  : out std_logic
        );
    end component;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';
    signal start : std_logic := '0';
    signal B     : cmatrixHigh;
    signal P     : cmatrixHigh;
    signal done  : std_logic;

    constant clk_period : time := 10 ns;

begin

    -- Instantiate Unit Under Test (UUT)
    uut: padeDenominator
        port map (
            clk   => clk,
            reset => reset,
            start => start,
            B     => B,
            P     => P,
            done  => done
        );

    -- Clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
        -- Declare a local variable for matrix initialization
        variable temp_var : cmatrixHigh;
    begin
        -- Initialize B to a 3x3 identity matrix
        for i in 0 to numBasisStates - 1 loop
            for j in 0 to numBasisStates - 1 loop
                if i = j then
                    temp_var(i)(j).re := to_sfixed(1, fixedHigh'high, fixedHigh'low);
                else
                    temp_var(i)(j).re := to_sfixed(0, fixedHigh'high, fixedHigh'low);
                end if;
                temp_var(i)(j).im := to_sfixed(0, fixedHigh'high, fixedHigh'low);
            end loop;
        end loop;
        B <= temp_var;

        -- Apply reset
        reset <= '1';
        wait for clk_period*2;
        reset <= '0';
        wait for clk_period*2;

        -- Start computation
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Wait for completion
        wait until done = '1';
        wait for clk_period*2;

        -- End simulation
        report "Simulation completed successfully";
        wait;
    end process;

end Behavioral;

