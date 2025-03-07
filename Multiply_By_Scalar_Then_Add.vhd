library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed.ALL;
use work.qTypes.ALL;

entity Multiply_By_Scalar_Then_Add is
    Port (
        A : in  cvector;   -- Input complex vector 1
        B : in  cvector;   -- Input complex vector 2
        C : in  cfixed;    -- Complex scalar multiplier
        Result : out cvector  -- Output complex vector (C*A + B)
    );
end Multiply_By_Scalar_Then_Add;

architecture Concurrent of Multiply_By_Scalar_Then_Add is
    -- Declare components
    component Multiply_Column_By_Scalar is
        Port (
            constComplex : in  cfixed;
            rowVector    : in  cvector;
            outputVector : out cvector
        );
    end component;

    component Add_Vectors_Element_Wise is
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
    Multiply_Stage: Multiply_Column_By_Scalar
        port map (
            constComplex => C,
            rowVector    => A,
            outputVector => c_times_A
        );

    -- Stage 2: Add (C*A) + B
    Add_Stage: Add_Vectors_Element_Wise
        port map (
            a => c_times_A,
            b => B,
            c => Result
        );

end architecture Concurrent;
