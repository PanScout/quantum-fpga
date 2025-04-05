library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed64.ALL;
use work.qTypes.ALL;

entity tb_Scale_CMatrix_Down is
end tb_Scale_CMatrix_Down;

architecture Behavioral of tb_Scale_CMatrix_Down is
    component Scale_CMatrixHigh_Down is
        port (
            Input_Matrix  : in  cmatrix;
            Shift_Amount  : in  fixed64;
            Output_Matrix : out cmatrix
        );
    end component;

    signal Input_Matrix  : cmatrix;
    signal Shift_Amount  : fixed64;
    signal Output_Matrix : cmatrix;
    
    -- Clock parameters (for timing demonstration)
    constant CLK_PERIOD : time := 10 ns;
    signal clk : std_logic := '0';
    
    -- Test values
    constant TEST_VALUE : real := 8.0;  -- Initial test value (8 = 2^3)
    constant ZERO       : sfixed(fixed64'high downto fixed64'low) := 
        to_sfixed(0, fixed64'high, fixed64'low);
begin
    -- Generate clock
    clk <= not clk after CLK_PERIOD/2;

    -- Instantiate DUT
    dut: Scale_CMatrixHigh_Down
    port map (
        Input_Matrix  => Input_Matrix,
        Shift_Amount  => Shift_Amount,
        Output_Matrix => Output_Matrix
    );

    -- Test stimulus process
    stim_proc: process
        procedure fill_matrix(value: real) is
            variable val_sf : sfixed(fixed64'high downto fixed64'low);
        begin
            val_sf := to_sfixed(value, fixed64'high, fixed64'low);
            for i in 0 to dimension-1 loop
                for j in 0 to dimension-1 loop
                    Input_Matrix(i)(j).re <= val_sf;
                    Input_Matrix(i)(j).im <= val_sf;
                end loop;
            end loop;
        end procedure;

        procedure verify_output(expected: real) is
            variable exp_sf : sfixed(fixed64'high downto fixed64'low);
        begin
            exp_sf := to_sfixed(expected, fixed64'high, fixed64'low);
            wait until rising_edge(clk);  -- Wait for propagation
            for i in 0 to dimension-1 loop
                for j in 0 to dimension-1 loop
                    assert Output_Matrix(i)(j).re = exp_sf
                        report "Real part error at (" & integer'image(i) & "," & integer'image(j) & ")" 
                        severity error;
                    assert Output_Matrix(i)(j).im = exp_sf
                        report "Imaginary part error at (" & integer'image(i) & "," & integer'image(j) & ")" 
                        severity error;
                end loop;
            end loop;
        end procedure;
    begin
        -- Initialize with known value (8.0)
        fill_matrix(TEST_VALUE);
        Shift_Amount <= to_sfixed(0, fixed64'high, fixed64'low);
        wait for CLK_PERIOD;

        -- Test Case 1: Zero shift (no change)
        report "Test 1: Zero shift";
        verify_output(8.0);

        -- Test Case 2: Shift right by 1 (divide by 2)
        report "Test 2: Shift by 1";
        Shift_Amount <= to_sfixed(1, fixed64'high, fixed64'low);
        verify_output(4.0);

        -- Test Case 3: Shift right by 3 (divide by 8)
        report "Test 3: Shift by 3";
        Shift_Amount <= to_sfixed(3, fixed64'high, fixed64'low);
        verify_output(1.0);

        -- Test Case 4: Negative shift amount (should use absolute value)
        report "Test 4: Negative shift amount (-2)";
        Shift_Amount <= to_sfixed(-2, fixed64'high, fixed64'low);
        verify_output(2.0);  -- 8 / 4 = 2

        -- Test Case 5: Large shift (overflow to zero)
        report "Test 5: Large shift (16)";
        Shift_Amount <= to_sfixed(16, fixed64'high, fixed64'low);
        verify_output(0.0);

        -- Test Case 6: Dynamic value change
        report "Test 6: Dynamic value test";
        fill_matrix(32.0);
        Shift_Amount <= to_sfixed(3, fixed64'high, fixed64'low);
        verify_output(4.0);  -- 32 / 8 = 4

        report "All tests completed";
        wait;
    end process;
end Behavioral;
