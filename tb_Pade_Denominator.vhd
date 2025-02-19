library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity tb_Pade_Denominator is
end tb_Pade_Denominator;

architecture test of tb_Pade_Denominator is

    -- Signals to drive the UUT
    signal B : cmatrixHigh;
    signal P : cmatrixHigh;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.Pade_Denominator
        port map (
            B => B,
            P => P
        );

    stimulus: process
        -- Declare a variable for building the test matrix.
        variable temp : cmatrixHigh;
        variable i, j : integer;
    begin
        -- Initialize matrix B: set every element's real part to 1 and imaginary part to 0.
        for i in 0 to numBasisStates - 1 loop
            for j in 0 to numBasisStates - 1 loop
                temp(i)(j).re := to_sfixed(1, fixedHigh'high, fixedHigh'low);
                temp(i)(j).im := to_sfixed(0, fixedHigh'high, fixedHigh'low);
            end loop;
        end loop;
        B <= temp;

        -- Wait sufficient time for the UUT output to settle.
        wait for 100 ns;

        -- Optionally, add report statements to display or check the output.
        -- For example:
        -- report "P(0,0).re = " & to_string(P(0)(0).re);

        wait;  -- End simulation.
    end process stimulus;

end test;

