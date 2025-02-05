library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity tb_matrixScalarMultiplication is
end tb_matrixScalarMultiplication;

architecture Behavioral of tb_matrixScalarMultiplication is
    component matrixScalarMultiplication is
        Port (
            A      : in  cmatrix;
            scalar : in  cfixed;
            C      : out cmatrix
        );
    end component;

    signal A, C : cmatrix;
    signal scalar : cfixed;
    constant epsilon : real := 0.001;

begin
    uut: matrixScalarMultiplication port map (
        A => A,
        scalar => scalar,
        C => C
    );

    stim_proc: process
        variable error_count : integer := 0;
    begin
        -- Initialize matrix and scalar
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                -- Input matrix: 3.0 + j4.0 for all elements
                A(i)(j).re <= to_sfixed(3.0, A(i)(j).re);
                A(i)(j).im <= to_sfixed(4.0, A(i)(j).im);
            end loop;
        end loop;
        
        -- Test scalar: 2.0 + j1.0
        scalar.re <= to_sfixed(2.0, scalar.re);
        scalar.im <= to_sfixed(3.0, scalar.im);
        
        wait for 10 ns;  -- Allow signals to propagate

        -- Verify complex multiplication results for all elements
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                -- Expected result: (3*2 - 4*1) + j(3*1 + 4*2) = 2.0 + j11.0
                
                -- Check real part
                if abs(to_real(C(i)(j).re) - 2.0) > epsilon then
                    report "Real part error at (" & integer'image(i) & "," & integer'image(j) & 
                           "): Expected 2.0, Got " & real'image(to_real(C(i)(j).re))
                           severity error;
                    error_count := error_count + 1;
                end if;
                
                -- Check imaginary part
                if abs(to_real(C(i)(j).im) - 11.0) > epsilon then
                    report "Imaginary part error at (" & integer'image(i) & "," & integer'image(j) & 
                           "): Expected 11.0, Got " & real'image(to_real(C(i)(j).im))
                           severity error;
                    error_count := error_count + 1;
                end if;
            end loop;
        end loop;

        -- Final report
        if error_count = 0 then
            report "Matrix scalar multiplication test passed!" severity note;
        else
            report "Test failed with " & integer'image(error_count) & " errors" severity failure;
        end if;
        wait;
    end process;

end Behavioral;
