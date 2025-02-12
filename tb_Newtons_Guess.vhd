library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity tb_Newtons_Guess is
end tb_Newtons_Guess;

architecture Behavioral of tb_Newtons_Guess is
    component Newtons_Guess is
        Port (
            A          : in  cmatrixHigh;
            scaled_AT  : out cmatrixHigh
        );
    end component;

    signal A : cmatrixHigh;
    signal scaled_AT : cmatrixHigh;
    
    -- Test matrix parameters
    constant TEST_VAL : real := 4.0;
    constant EXPECTED_SCALE : real := 1.0/(16.0 * 4.0);  -- 1/64 = 0.015625
    constant TOLERANCE : real := 1.0e-10;

begin
    uut: Newtons_Guess
    port map (
        A => A,
        scaled_AT => scaled_AT
    );

    stim_proc: process
        variable expected_re, actual_re : real;
    begin
        -- Initialize test matrix (first row = 4.0, others = 0.0)
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                if i = 0 then
                    A(i)(j).re <= to_sfixed(TEST_VAL, fixedHigh'high, fixedHigh'low);
                else
                    A(i)(j).re <= to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
                end if;
                A(i)(j).im <= to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
            end loop;
        end loop;

        wait for 1 ns;  -- Allow combinatorial logic to settle

        -- Verify results
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                actual_re := to_real(scaled_AT(i)(j).re);
                
                -- Expected value calculation
                if j = 0 then  -- First column of transpose
                    expected_re := TEST_VAL * EXPECTED_SCALE;
                else
                    expected_re := 0.0;
                end if;

                -- Check real part
                assert abs(actual_re - expected_re) < TOLERANCE
                    report "Mismatch at (" & integer'image(i) & "," & integer'image(j) & 
                           "): Expected " & real'image(expected_re) & 
                           ", Got " & real'image(actual_re)
                    severity error;

                -- Check imaginary part (should always be zero)
                assert to_real(scaled_AT(i)(j).im) = 0.0
                    report "Non-zero imaginary at (" & integer'image(i) & "," & integer'image(j) & 
                           "): " & real'image(to_real(scaled_AT(i)(j).im))
                    severity error;
            end loop;
        end loop;

        report "Test completed successfully";
        wait;
    end process;

end Behavioral;
