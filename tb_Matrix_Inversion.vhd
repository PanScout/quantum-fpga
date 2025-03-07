library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.fixed.ALL;
use work.qTypes.all;

entity tb_Matrix_Inversion is
end tb_Matrix_Inversion;

architecture Behavioral of tb_Matrix_Inversion is
    component Matrix_Inversion is
        Port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            start           : in  std_logic;
            input_matrix    : in  cmatrixHigh;
            output_matrix   : out cmatrixHigh;
            done            : out std_logic
        );
    end component;

    -- Clock parameters
    constant CLK_PERIOD : time := 10 ns;
    
    -- Custom matrix type definitions
    type real_row is array (0 to numBasisStates-1) of real;
    type real_matrix is array (0 to numBasisStates-1) of real_row;
    
    -- #########################################################################
    -- # USER-CONFIGURABLE AREA - INPUT YOUR MATRIX HERE
    -- #########################################################################
    constant MATRIX_REAL : real_matrix := (
        (-17635117961.8806, 0.0, 0.0, 0.0),  -- Row 0
        (0.0, -17635117961.8806, 0.0, 0.0),  -- Row 1
        (0.0, 0.0, -17635117961.8806, 0.0),  -- Row 2
        (0.0, 0.0, 0.0, -17635117961.8806)   -- Row 3
    );
    
    constant MATRIX_IMAG : real_matrix := (
        (551276900.108857, 0.0, 0.0, 0.0),  -- Row 0
        (0.0, 551276900.108857, 0.0, 0.0),  -- Row 1
        (0.0, 0.0, 551276900.108857, 0.0),  -- Row 2
        (0.0, 0.0, 0.0, 551276900.108857)   -- Row 3
    );
    -- #########################################################################
    -- # END OF USER-CONFIGURABLE AREA
    -- #########################################################################

    -- Test parameters
    constant TOLERANCE : real := 1.0e-4;

    -- Signals
    signal clk, rst, start, done : std_logic := '0';
    signal input_matrix, output_matrix : cmatrixHigh;
    
begin
    -- Instantiate DUT
    uut: Matrix_Inversion
    port map (
        clk => clk,
        rst => rst,
        start => start,
        input_matrix => input_matrix,
        output_matrix => output_matrix,
        done => done
    );

    -- Clock generation
    clk <= not clk after CLK_PERIOD/2;

    -- Initialize input matrix from constants
    gen_matrix_input: for i in 0 to numBasisStates-1 generate
        gen_matrix_col: for j in 0 to numBasisStates-1 generate
            input_matrix(i)(j).re <= to_sfixed(MATRIX_REAL(i)(j), fixedHigh'high, fixedHigh'low);
            input_matrix(i)(j).im <= to_sfixed(MATRIX_IMAG(i)(j), fixedHigh'high, fixedHigh'low);
        end generate gen_matrix_col;
    end generate gen_matrix_input;

    -- Stimulus and verification process
    stim_proc: process
        variable product_re, product_im : real;
        variable tmp_re, tmp_im : real;
    begin
        -- Reset system
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- Start inversion
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        -- Wait for completion
        wait until done = '1';
        wait for CLK_PERIOD*2;

        -- Verify inversion through matrix multiplication
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                product_re := 0.0;
                product_im := 0.0;
                
                -- Calculate product matrix element (i,j)
                for k in 0 to numBasisStates-1 loop
                    -- Convert fixed-point to real
                    tmp_re := to_real(input_matrix(i)(k).re);
                    tmp_im := to_real(input_matrix(i)(k).im);
                    
                    -- Complex multiplication
                    product_re := product_re + 
                        (tmp_re * to_real(output_matrix(k)(j).re) - 
                         tmp_im * to_real(output_matrix(k)(j).im));
                    product_im := product_im + 
                        (tmp_re * to_real(output_matrix(k)(j).im) + 
                         tmp_im * to_real(output_matrix(k)(j).re));
                end loop;

                -- Verify against identity matrix
                if i = j then
                    assert abs(product_re - 1.0) < TOLERANCE
                        report "Diagonal error at (" & integer'image(i) & "," & integer'image(j) & 
                               "): Expected 1.0, Got " & real'image(product_re)
                        severity error;
                else
                    assert abs(product_re) < TOLERANCE
                        report "Off-diagonal real error at (" & integer'image(i) & "," & integer'image(j) & 
                               "): Expected 0.0, Got " & real'image(product_re)
                        severity error;
                end if;
                
                assert abs(product_im) < TOLERANCE
                    report "Imaginary error at (" & integer'image(i) & "," & integer'image(j) & 
                           "): Expected 0.0, Got " & real'image(product_im)
                    severity error;
            end loop;
        end loop;

        report "Test completed successfully";
        wait;
    end process;

end Behavioral;
