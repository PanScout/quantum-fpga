library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity multiplyThenAddVectors is
    Port (
        A : in  cvector;   -- Input complex vector 1
        B : in  cvector;   -- Input complex vector 2
        C : in  cfixed;    -- Complex scalar multiplier
        Result : out cvector  -- Output complex vector (C*A + B)
    );
end multiplyThenAddVectors;

architecture Concurrent of multiplyThenAddVectors is
    -- Declare components
    component multiplyColumnByScalar is
        Port (
            constComplex : in  cfixed;
            rowVector    : in  cvector;
            outputVector : out cvector
        );
    end component;

    component cvector_adder is
        Port (
            a : in  cvector;
            b : in  cvector;
            c : out cvector
        );
    end component;

    -- Internal signal for intermediate result
    signal c_times_A : cvector;

begin
    -- Stage 1: Multiply C * A
    Multiply_Stage: multiplyColumnByScalar
        port map (
            constComplex => C,
            rowVector    => A,
            outputVector => c_times_A
        );

    -- Stage 2: Add (C*A) + B
    Add_Stage: cvector_adder
        port map (
            a => c_times_A,
            b => B,
            c => Result
        );

end architecture Concurrent;
