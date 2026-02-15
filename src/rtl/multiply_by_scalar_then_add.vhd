library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

entity multiply_by_scalar_then_add is
    Port (
        A : in  cvector;   -- Input complex vector 1
        B : in  cvector;   -- Input complex vector 2
        C : in  csfixed36;    -- Complex scalar multiplier
        Result : out cvector  -- Output complex vector (C*A + B)
    );
end multiply_by_scalar_then_add;

architecture Concurrent of multiply_by_scalar_then_add is
    -- Declare components
    component multiply_column_by_scalar is
        Port (
            constComplex : in  csfixed36;
            rowVector    : in  cvector;
            outputVector : out cvector
        );
    end component;

    component add_vectors_element_wise is
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
    Multiply_Stage_High: multiply_column_by_scalar
        port map (
            constComplex => C,
            rowVector    => A,
            outputVector => c_times_A
        );

    -- Stage 2: Add (C*A) + B
    Add_Stage_High: add_vectors_element_wise
        port map (
            a => c_times_A,
            b => B,
            c => Result
        );

end architecture Concurrent;
