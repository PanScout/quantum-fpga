library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

entity tb_padeDenominator is
end tb_padeDenominator;

architecture Behavioral of tb_padeDenominator is

    component padeDenominator is
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            start : in  std_logic;
            B     : in  cmatrix;
            P     : out cmatrix;
            done  : out std_logic
        );
    end component;

    -- Signals
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal start    : std_logic := '0';
    signal done     : std_logic;
    signal B, P     : cmatrix;

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

    -- Function to initialize matrix with real scalar value
    function init_cmatrixHigh_scalar(value_real : real) return cmatrix is
        variable matrix : cmatrix;
    begin
        for i in matrix'range loop
            for j in matrix(i)'range loop
                matrix(i)(j).re := to_sfixed(value_real, fixed64'high, fixed64'low);
                matrix(i)(j).im := to_sfixed(0.0, fixed64'high, fixed64'low);
            end loop;
        end loop;
        return matrix;
    end function;

    -- Procedure to print matrix values
    procedure print_cmatrixHigh(matrix : cmatrix; name : string) is
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

    -- Instantiate Unit Under Test
    uut: padeDenominator
        port map (
            clk   => clk,
            reset => reset,
            start => start,
            B     => B,
            P     => P,
            done  => done
        );

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Stimulus process
    process
        variable expected_P : real;
    begin
        -- Initialize B matrix with all 1s
        B <= init_cmatrixHigh_scalar(1.0);
        print_cmatrixHigh(B, "Input B");

        -- Reset system
        reset <= '1';
        wait for CLK_PERIOD * 2;
        reset <= '0';
        wait for CLK_PERIOD;

        -- Start computation
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        -- Wait for computation to complete
        wait until done = '1';
        wait for CLK_PERIOD;

        -- Verify result (expected_P = -71.0 for B = 1.0)
        expected_P := -71.0;  -- ((((1-12)*1)+60)*1-120) = -71
        for i in P'range loop
            for j in P(i)'range loop
                assert to_real(P(i)(j).re) = expected_P
                    report "Mismatch at (" & integer'image(i) & "," & integer'image(j) & "): " &
                           "Expected " & real'image(expected_P) & 
                           ", Got " & real'image(to_real(P(i)(j).re))
                    severity error;
            end loop;
        end loop;
        print_cmatrixHigh(P, "Output P");

        report "Testbench completed successfully";
        wait;
    end process;

end Behavioral;
