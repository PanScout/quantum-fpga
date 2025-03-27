library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed64.ALL;
use work.qTypes.ALL;

entity TB_Matrix_By_Matrix_Multiplication_High is
    -- Testbench has no ports.
end TB_Matrix_By_Matrix_Multiplication_High;

architecture Behavioral of TB_Matrix_By_Matrix_Multiplication_High is

    ----------------------------------------------------------------------------
    -- Signal Declarations
    ----------------------------------------------------------------------------
    signal A : cmatrix := (
        0 => ( 0 => (re => to_sfixed( 1, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed( 2, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed( 3, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed( 4, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             ),
        1 => ( 0 => (re => to_sfixed( 5, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed( 6, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed( 7, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed( 8, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             ),
        2 => ( 0 => (re => to_sfixed( 9, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed(10, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed(11, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed(12, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             ),
        3 => ( 0 => (re => to_sfixed(13, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed(14, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed(15, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed(16, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             )
    );

    signal B : cmatrix := (
        0 => ( 0 => (re => to_sfixed(16, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed(15, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed(14, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed(13, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             ),
        1 => ( 0 => (re => to_sfixed(12, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed(11, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed(10, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed( 9, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             ),
        2 => ( 0 => (re => to_sfixed( 8, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed( 7, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed( 6, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed( 5, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             ),
        3 => ( 0 => (re => to_sfixed( 4, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               1 => (re => to_sfixed( 3, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               2 => (re => to_sfixed( 2, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low)),
               3 => (re => to_sfixed( 1, fixed64'high, fixed64'low), im => to_sfixed(0, fixed64'high, fixed64'low))
             )
    );

    signal C : cmatrix;  -- Output from the DUT (the multiplication result)

begin

    ----------------------------------------------------------------------------
    -- Instantiate the DUT (Matrix Multiplication Component)
    ----------------------------------------------------------------------------
    uut: entity work.Matrix_By_Matrix_Multiplication
        port map (
            A => A,
            B => B,
            C => C
        );

    ----------------------------------------------------------------------------
    -- Stimulus Process
    -- After a sufficient delay, loop through and print each element of C.
    ----------------------------------------------------------------------------
    stim_proc: process
    begin
        wait for 100 ns;  -- Wait for the DUT to complete multiplication

        for i in C'range loop
            for j in C(0)'range loop
                report "C(" & integer'image(i) & "," & integer'image(j) & 
                       ") = (" & to_string(C(i)(j).re) & ", " & to_string(C(i)(j).im) & ")";
            end loop;
        end loop;

        report "Testbench simulation complete. Inspect the above messages for the multiplication result.";
        wait;
    end process stim_proc;

end Behavioral;

