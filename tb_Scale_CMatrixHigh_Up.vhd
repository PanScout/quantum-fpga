library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity tb_Scale_CMatrixHigh_Up is
end tb_Scale_CMatrixHigh_Up;

architecture Behavioral of tb_Scale_CMatrixHigh_Up is
    constant numBasisStates : integer := 4;
    constant CLK_PERIOD     : time := 10 ns;
    
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '1';
    signal B      : cmatrixHigh := (others => (others => (
        re => to_sfixed(0.0, fixedHigh'high, fixedHigh'low),
        im => to_sfixed(0.0, fixedHigh'high, fixedHigh'low)
    )));
    signal S      : fixedHigh := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
    signal Result : cmatrixHigh;
    signal done   : std_logic;

    -- Clock cycle counter for timing control
    signal cycle_count : natural := 0;

begin
    uut: entity work.Scale_CMatrixHigh_Up
        port map (
            clk    => clk,
            reset  => reset,
            B      => B,
            S      => S,
            Result => Result,
            done   => done
        );

    clk <= not clk after CLK_PERIOD/2;

    -- Clock cycle counter
    process(clk)
    begin
        if rising_edge(clk) then
            cycle_count <= cycle_count + 1;
        end if;
    end process;

    stim_proc: process
        impure function to_cfixed(real_val, imag_val : real) return cfixedHigh is
        begin
            return (
                re => to_sfixed(real_val, fixedHigh'high, fixedHigh'low),
                im => to_sfixed(imag_val, fixedHigh'high, fixedHigh'low)
            );
        end function;

        procedure wait_cycles(n : natural) is
        begin
            for i in 1 to n loop
                wait until rising_edge(clk);
            end loop;
        end procedure;
    begin
        -- Phase 1: Initial reset
        reset <= '1';
        wait_cycles(2);
        reset <= '0';
        report "Reset released at cycle " & integer'image(cycle_count);

        -- Phase 2: Test case setup
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                B(i)(j) <= to_cfixed(1.0, 0.0);
            end loop;
        end loop;
        S <= to_sfixed(2.0, fixedHigh'high, fixedHigh'low);
        report "Test input applied at cycle " & integer'image(cycle_count);

        -- Phase 3: Wait for completion with timeout
        wait until done = '1' for 20*CLK_PERIOD;
        if done /= '1' then
            report "Timeout waiting for done signal" severity error;
        else
            report "Calculation completed at cycle " & integer'image(cycle_count);
            
            -- Phase 4: Result verification
            for i in 0 to numBasisStates-1 loop
                for j in 0 to numBasisStates-1 loop
                    -- Check real part with 1% tolerance
                    assert abs(Result(i)(j).re - 64.0) < 0.64
                        report "Real error at (" & integer'image(i) & "," & integer'image(j) & 
                               "): Expected 64.0, Got " & real'image(to_real(Result(i)(j).re))
                        severity error;
                        
                    -- Check imaginary part
                    assert Result(i)(j).im = to_sfixed(0.0, fixedHigh'high, fixedHigh'low)
                        report "Imaginary error at (" & integer'image(i) & "," & integer'image(j) & ")"
                        severity error;
                end loop;
            end loop;
        end if;

        -- Phase 5: End simulation
        wait_cycles(2);
        report "Simulation completed at cycle " & integer'image(cycle_count);
        wait;
    end process;

end Behavioral;
