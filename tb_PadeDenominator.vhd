library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Include your fixed?point and complex type definitions
--use work.fixed.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity tb_padeDenominator is
end tb_padeDenominator;

architecture sim of tb_padeDenominator is
    -- Testbench signals
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal start : std_logic := '0';
    signal B     : cmatrixHigh;
    signal P     : cmatrixHigh;
    signal done  : std_logic;
    
    -- For this example we assume cmatrixHigh is a 2x2 array.
    -- We initialize a sample B matrix with nonzero fixed-point values.
    constant sample_B : cmatrixHigh := (
        0 => (
            0 => ( re => to_sfixed(1, fixedHigh'high, fixedHigh'low),
                   im => to_sfixed(0, fixedHigh'high, fixedHigh'low) ),
            1 => ( re => to_sfixed(2, fixedHigh'high, fixedHigh'low),
                   im => to_sfixed(0, fixedHigh'high, fixedHigh'low) )
        ),
        1 => (
            0 => ( re => to_sfixed(3, fixedHigh'high, fixedHigh'low),
                   im => to_sfixed(0, fixedHigh'high, fixedHigh'low) ),
            1 => ( re => to_sfixed(4, fixedHigh'high, fixedHigh'low),
                   im => to_sfixed(0, fixedHigh'high, fixedHigh'low) )
        )
    );
    
begin

    -- Instantiate the DUT (Design Under Test)
    DUT: entity work.padeDenominator
        port map(
            clk   => clk,
            reset => reset,
            start => start,
            B     => B,
            P     => P,
            done  => done
        );
        
    -- Clock generation: 20 ns period (10 ns low, 10 ns high)
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;
    
    -- Stimulus process
    stim_process : process
    begin
        -- Apply an initial value for input matrix B.
        B <= sample_B;
        
        -- Assert reset to initialize the DUT.
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
        
        -- Start the operation.
        start <= '1';
        wait for 20 ns;
        start <= '0';
        
        -- Wait until the operation is complete (done signal asserted).
        wait until done = '1';
        
        -- Wait a short time to observe final output P.
        wait for 20 ns;
        
        -- Report completion (if your simulation tool supports reporting complex types,
        -- you may need to convert P to a string or inspect the waveform).
        report "Test completed. Output matrix P has been computed." severity note;
        
        wait;  -- Stop simulation.
    end process;
    
end sim;

