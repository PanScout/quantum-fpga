library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed.ALL;
use work.qTypes.ALL;

entity tb_Pade_Numerator is
end tb_Pade_Numerator;

architecture Behavioral of tb_Pade_Numerator is
    component Pade_Numerator is
        Port (
            B : in  cmatrixHigh;
            P : out cmatrixHigh
        );
    end component;

    signal B : cmatrixHigh;
    signal P : cmatrixHigh;
    
    constant CLK_PERIOD : time := 10 ns;
    signal clk : std_logic := '0';
    
    -- Test parameters
    constant MATRIX_SIZE : integer := numBasisStates;
    constant DELTA       : real := 1.0e-6;  -- Allowed error margin
    
    -- Expected value for 1x1 matrix with all ones
    constant EXPECTED_1x1 : real := 28875761731.0;

begin
    clk <= not clk after CLK_PERIOD/2;

    uut: Pade_Numerator port map (B => B, P => P);

    stimulus: process
        -- Fill matrix with specified real value (1.0) and 0 imaginary
        procedure fill_ones is
            variable temp: cfixedHigh;
        begin
            temp.re := to_sfixed(1.0, fixedHigh'high, fixedHigh'low);
            temp.im := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
            for i in 0 to MATRIX_SIZE-1 loop
                for j in 0 to MATRIX_SIZE-1 loop
                    B(i)(j) <= temp;
                end loop;
            end loop;
        end procedure;

        procedure verify_matrix(constant expected_real: real) is
            variable expected, actual: real;
        begin
            wait until rising_edge(clk);
            wait for 1 ns;
            for i in 0 to MATRIX_SIZE-1 loop
                for j in 0 to MATRIX_SIZE-1 loop
                    -- Check real part
                    expected := expected_real;
                    actual := to_real(P(i)(j).re);
                    assert abs(actual - expected) <= DELTA
                        report "Real mismatch at (" & integer'image(i) & "," & integer'image(j) & "): " &
                               "Expected " & real'image(expected) & 
                               ", Got " & real'image(actual)
                        severity error;
                    
                    -- Check imaginary part
                    actual := to_real(P(i)(j).im);
                    assert abs(actual - 0.0) <= DELTA
                        report "Imaginary mismatch at (" & integer'image(i) & "," & integer'image(j) & "): " &
                               "Expected 0.0, Got " & real'image(actual)
                        severity error;
                end loop;
            end loop;
        end procedure;

    begin
        -- Test Case: All ones matrix
        report "Test: Matrix filled with ones";
        fill_ones;
        
        -- Only verify if matrix is 1x1 (known expected value)
        if MATRIX_SIZE = 1 then
            verify_matrix(EXPECTED_1x1);
        else
            report "Warning: Verification skipped for non-1x1 matrix" severity warning;
        end if;

        report "All tests completed";
        wait;
    end process;
end Behavioral;
