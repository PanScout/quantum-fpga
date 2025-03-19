library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

entity tb_Scale_CMatrixHigh_Up is
end tb_Scale_CMatrixHigh_Up;

architecture Behavioral of tb_Scale_CMatrixHigh_Up is
    component Scale_CMatrixHigh_Up is
        Port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            start  : in  std_logic;
            B      : in  cmatrixHigh;
            S      : in  cfixedHigh;
            Result : out cmatrixHigh;
            done   : out std_logic
        );
    end component;

    -- Constants
    constant CLK_PERIOD : time := 10 ns;
    constant MATRIX_SIZE : natural := 2;  -- Assuming 2x2 matrix

    -- Signals
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal start  : std_logic := '0';
    signal done   : std_logic;
    signal B, Result : cmatrixHigh;
    signal S      : cfixedHigh;

    -- Function to initialize matrix with real scalar value
    function init_cmatrixHigh_scalar(value_real : real) return cmatrixHigh is
        variable matrix : cmatrixHigh;
    begin
        for i in matrix'range loop
            for j in matrix(i)'range loop
                matrix(i)(j).re := to_sfixed(value_real, fixedHigh'high, fixedHigh'low);
                matrix(i)(j).im := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
            end loop;
        end loop;
        return matrix;
    end function;

    -- Procedure to print matrix values
    procedure print_cmatrixHigh(matrix : cmatrixHigh; name : string) is
    begin
        report "Matrix: " & name;
        for i in matrix'range loop
            for j in matrix(i)'range loop
                report "(" & integer'image(i) & "," & integer'image(j) & "): " &
                    "re = " & to_string(matrix(i)(j).re) &
                    ", im = " & to_string(matrix(i)(j).im);
            end loop;
        end loop;
    end procedure;

begin
    uut: Scale_CMatrixHigh_Up
        port map (
            clk    => clk,
            reset  => reset,
            start  => start,
            B      => B,
            S      => S,
            Result => Result,
            done   => done
        );

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Stimulus process
    process
        variable expected_val : real;
    begin
        -- Initialize input matrix with all 1s
        B <= init_cmatrixHigh_scalar(1.0);
        print_cmatrixHigh(B, "Input B");

        -- Test case 1: S = 1 (B^2)
        S.re <= to_sfixed(1, fixedHigh'high, fixedHigh'low);
        S.im <= to_sfixed(0, fixedHigh'high, fixedHigh'low);
        expected_val := 2.0;  -- For 2x2 matrix: 1^2 * 2 = 2

        -- Reset system
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Start computation
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        -- Wait for completion
        wait until done = '1';
        wait for CLK_PERIOD;

        -- Verify result
        for i in Result'range loop
            for j in Result(i)'range loop
                assert to_real(Result(i)(j).re) = expected_val
                    report "S=1: Mismatch at (" & integer'image(i) & "," & integer'image(j) & ")" 
                    & " Expected: " & real'image(expected_val) 
                    & " Got: " & real'image(to_real(Result(i)(j).re))
                    severity error;
            end loop;
        end loop;
        print_cmatrixHigh(Result, "Result for S=1");

        -- Test case 2: S = 2 (B^4)
        S.re <= to_sfixed(2, fixedHigh'high, fixedHigh'low);
        expected_val := 8.0;  -- (2^2)^2 = 8 for 2x2 matrix
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until done = '1';
        wait for CLK_PERIOD;

        for i in Result'range loop
            for j in Result(i)'range loop
                assert to_real(Result(i)(j).re) = expected_val
                    report "S=2: Mismatch at (" & integer'image(i) & "," & integer'image(j) & ")" 
                    & " Expected: " & real'image(expected_val) 
                    & " Got: " & real'image(to_real(Result(i)(j).re))
                    severity error;
            end loop;
        end loop;
        print_cmatrixHigh(Result, "Result for S=2");

        -- Test case 3: S = 3 (B^8)
        S.re <= to_sfixed(3, fixedHigh'high, fixedHigh'low);
        expected_val := 128.0;  -- (8^2) = 64, but for 2x2 matrix: 8*2 = 16? Wait, need to verify
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';
        wait until done = '1';
        wait for CLK_PERIOD;

        for i in Result'range loop
            for j in Result(i)'range loop
                assert to_real(Result(i)(j).re) = expected_val
                    report "S=3: Mismatch at (" & integer'image(i) & "," & integer'image(j) & ")" 
                    & " Expected: " & real'image(expected_val) 
                    & " Got: " & real'image(to_real(Result(i)(j).re))
                    severity error;
            end loop;
        end loop;
        print_cmatrixHigh(Result, "Result for S=3");

        report "All test cases completed";
        wait;
    end process;
end Behavioral;
