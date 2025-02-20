library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.ALL;

entity tb_Matrix_By_Matrix_Multiplication is
end tb_Matrix_By_Matrix_Multiplication;

architecture sim of tb_Matrix_By_Matrix_Multiplication is

    constant N : integer := numBasisStates;
    
    signal A : cmatrix := (others => (others => (re => (others => '0'), im => (others => '0'))));
    signal B : cmatrix := (others => (others => (re => (others => '0'), im => (others => '0'))));
    signal C : cmatrix;

begin

    UUT: entity work.Matrix_By_Matrix_Multiplication
        port map (
            A => A,
            B => B,
            C => C
        );

    -- synthesis translate_off
    stim_proc: process
    begin
        -- Provide stimulus to matrix A.
        A(0) <= (0 => (re => "0000000000000001", im => "0000000000000000"),
                 1 => (re => "0000000000000010", im => "0000000000000000"),
                 2 => (re => "0000000000000011", im => "0000000000000000"),
                 3 => (re => "0000000000000100", im => "0000000000000000"));
        A(1) <= (0 => (re => "0000000000000101", im => "0000000000000000"),
                 1 => (re => "0000000000000110", im => "0000000000000000"),
                 2 => (re => "0000000000000111", im => "0000000000000000"),
                 3 => (re => "0000000000001000", im => "0000000000000000"));
        A(2) <= (0 => (re => "0000000000001001", im => "0000000000000000"),
                 1 => (re => "0000000000001010", im => "0000000000000000"),
                 2 => (re => "0000000000001011", im => "0000000000000000"),
                 3 => (re => "0000000000001100", im => "0000000000000000"));
        A(3) <= (0 => (re => "0000000000001101", im => "0000000000000000"),
                 1 => (re => "0000000000001110", im => "0000000000000000"),
                 2 => (re => "0000000000001111", im => "0000000000000000"),
                 3 => (re => "0000000000010000", im => "0000000000000000"));

        -- Provide stimulus to matrix B.
        B(0) <= (0 => (re => "0000000000010001", im => "0000000000000000"),
                 1 => (re => "0000000000010010", im => "0000000000000000"),
                 2 => (re => "0000000000010011", im => "0000000000000000"),
                 3 => (re => "0000000000010100", im => "0000000000000000"));
        B(1) <= (0 => (re => "0000000000010101", im => "0000000000000000"),
                 1 => (re => "0000000000010110", im => "0000000000000000"),
                 2 => (re => "0000000000010111", im => "0000000000000000"),
                 3 => (re => "0000000000011000", im => "0000000000000000"));
        B(2) <= (0 => (re => "0000000000011001", im => "0000000000000000"),
                 1 => (re => "0000000000011010", im => "0000000000000000"),
                 2 => (re => "0000000000011011", im => "0000000000000000"),
                 3 => (re => "0000000000011100", im => "0000000000000000"));
        B(3) <= (0 => (re => "0000000000011101", im => "0000000000000000"),
                 1 => (re => "0000000000011110", im => "0000000000000000"),
                 2 => (re => "0000000000011111", im => "0000000000000000"),
                 3 => (re => "0000000000100000", im => "0000000000000000"));

        ---wait for 100 ns;
        --report "Test bench simulation complete" severity note;
        --wait until false;  -- Infinite wait to halt simulation.
    end process stim_proc;
    -- synthesis translate_on

end architecture sim;
