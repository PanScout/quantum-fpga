library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity TB_Matrix_By_Matrix_Multiplication_High is
    -- Testbench has no ports.
end TB_Matrix_By_Matrix_Multiplication_High;

architecture Behavioral of TB_Matrix_By_Matrix_Multiplication_High is

    -- Signals to drive the DUT
    signal A : cmatrixHigh := (
        0 => ( 0 => (re => to_sfixed(1,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(2,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(3,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(4,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             ),
        1 => ( 0 => (re => to_sfixed(5,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(6,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(7,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(8,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             ),
        2 => ( 0 => (re => to_sfixed(9,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(10, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(11, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(12, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             ),
        3 => ( 0 => (re => to_sfixed(13, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(14, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(15, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(16, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             )
    );

    signal B : cmatrixHigh := (
        0 => ( 0 => (re => to_sfixed(16, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(15, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(14, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(13, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             ),
        1 => ( 0 => (re => to_sfixed(12, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(11, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(10, fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(9,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             ),
        2 => ( 0 => (re => to_sfixed(8,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(7,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(6,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(5,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             ),
        3 => ( 0 => (re => to_sfixed(4,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               1 => (re => to_sfixed(3,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               2 => (re => to_sfixed(2,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low)),
               3 => (re => to_sfixed(1,  fixedHigh'high, fixedHigh'low), im => to_sfixed(0, fixedHigh'high, fixedHigh'low))
             )
    );

    signal C : cmatrixHigh;  -- Output of the matrix multiplication

begin

    -- Instantiate the DUT (Device Under Test)
    uut: entity work.Matrix_By_Matrix_Multiplication_High
        port map (
            A => A,
            B => B,
            C => C
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Wait long enough for the matrix multiplication to be computed.
        wait for 100 ns;
        report "Testbench simulation complete. Inspect signal C for results.";
        wait;  -- End simulation (in a simulator, you might use an assertion or stop command)
    end process;

end Behavioral;

