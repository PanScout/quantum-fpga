library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.all;  -- Use only one fixed64-point package
use work.qTypes.all;

entity tb_Matrix_Inversion is
end tb_Matrix_Inversion;

architecture Behavioral of tb_Matrix_Inversion is
    component Matrix_Inversion is
        Port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            start           : in  std_logic;
            input_matrix    : in  cmatrix;
            output_matrix   : out cmatrix;
            done            : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;
    
    -- Updated for 2x2 matrix (matches cmatrix dimensions)
    type real_row is array (0 to 1) of real;
    type real_matrix is array (0 to 1) of real_row;
    
    constant MATRIX_REAL : real_matrix := (
        (-17635117961.8806, 0.0),    -- Row 0
        (0.0, -17635117961.8806)     -- Row 1
    );
    
    constant MATRIX_IMAG : real_matrix := (
        (551276900.108857, 0.0),     -- Row 0
        (0.0, 551276900.108857)      -- Row 1
    );

    constant TOLERANCE : real := 1.0e-4;

    signal clk, rst, start, done : std_logic := '0';
    signal input_matrix, output_matrix : cmatrix;
    
begin
    uut: Matrix_Inversion port map (
        clk => clk,
        rst => rst,
        start => start,
        input_matrix => input_matrix,
        output_matrix => output_matrix,
        done => done
    );

    clk <= not clk after CLK_PERIOD/2;

    -- Concurrent matrix initialization
    init_matrix: process
    begin
        for i in 0 to 1 loop
            for j in 0 to 1 loop
                input_matrix(i)(j).re <= to_sfixed(MATRIX_REAL(i)(j), input_matrix(i)(j).re);
                input_matrix(i)(j).im <= to_sfixed(MATRIX_IMAG(i)(j), input_matrix(i)(j).im);
            end loop;
        end loop;
        wait;
    end process;

    stim_proc: process
        variable product_re, product_im : real;
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        wait for CLK_PERIOD*2;

        -- Verification
        for i in 0 to 1 loop
            for j in 0 to 1 loop
                product_re := 0.0;
                product_im := 0.0;
                
                for k in 0 to 1 loop
                    product_re := product_re + 
                        (to_real(input_matrix(i)(k).re) * to_real(output_matrix(k)(j).re) - 
                         to_real(input_matrix(i)(k).im) * to_real(output_matrix(k)(j).im));
                    product_im := product_im + 
                        (to_real(input_matrix(i)(k).re) * to_real(output_matrix(k)(j).im) + 
                         to_real(input_matrix(i)(k).im) * to_real(output_matrix(k)(j).re));
                end loop;

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
