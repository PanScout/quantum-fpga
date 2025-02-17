library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity tb_matrixAddition_simple is
end tb_matrixAddition_simple;

architecture Behavioral of tb_matrixAddition_simple is
    component matrixAddition is
        Port (
            A : in  cmatrix;
            B : in  cmatrix;
            C : out cmatrix
        );
    end component;

    signal A, B, C : cmatrix;
    signal test_pass : boolean := true;
    constant epsilon : real := 0.001;

begin
    uut: matrixAddition port map (A => A, B => B, C => C);

    stim_proc: process
        variable error_count : integer := 0;
        variable expected_real : integer := 4;
        variable expected_imag : integer := 6;
    begin
        -- Initialize matrices with distinct real/imaginary values
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                -- Matrix A: real = 1.0, imaginary = 2.0
                --A(i)(j).re <= to_sfixed(1.0, A(i)(j).re);
                --A(i)(j).im <= to_sfixed(12.0, A(i)(j).im);
                A(i)(j).re <= std_logic_vector(to_signed(1, 16));
                A(i)(j).im <= std_logic_vector(to_signed(12, 16));
                
                -- Matrix B: real = 3.0, imaginary = 4.0
                --B(i)(j).re <= to_sfixed(3.0, B(i)(j).re);
                --B(i)(j).im <= to_sfixed(14.0, B(i)(j).im);
                B(i)(j).re <= std_logic_vector(to_signed(3, 16));
                B(i)(j).im <= std_logic_vector(to_signed(14, 16));
            end loop;
        end loop;
        wait for 10 ns;  -- Allow signals to propagate

        -- Check results for all elements
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                -- Expected result: real = 4.0, imaginary = 6.0
                --if abs(to_real(C(i)(j).re) - 4.0) > epsilon then
                    --report "Real part error at (" & integer'image(i) & "," & integer'image(j) & 
                           --"): Expected 4.0, Got " & real'image(to_real(C(i)(j).re))
                           --severity error;
                    --error_count := error_count + 1;
                --end if;
                if signed(C(i)(j).re) /= to_signed(expected_real, 16) then
                    report "Real part error at (" & integer'image(i) & "," & integer'image(j) & 
                           "): Expected 4, Got " & integer'image(to_integer(signed(C(i)(j).re)))
                           severity error;
                    error_count := error_count + 1;
                end if;
                
                --if abs(to_real(C(i)(j).im) - 6.0) > epsilon then
                    --report "Imaginary part error at (" & integer'image(i) & "," & integer'image(j) & 
                           --"): Expected 6.0, Got " & real'image(to_real(C(i)(j).im))
                           --severity error;
                    --error_count := error_count + 1;
                --end if;
                if signed(C(i)(j).im) /= to_signed(expected_imag, 16) then
                    report "Imaginary part error at (" & integer'image(i) & "," & integer'image(j) & 
                           "): Expected 6, Got " & integer'image(to_integer(signed(C(i)(j).im)))
                           severity error;
                    error_count := error_count + 1;
                end if;
            end loop;
        end loop;

        -- Final report
        if error_count = 0 then
            report "Matrix addition test passed: All real and imaginary components correct!" 
                   severity note;
        else
            report "Matrix addition failed with " & integer'image(error_count) & " errors!" 
                   severity failure;
        end if;
        wait;
    end process;

end Behavioral;
