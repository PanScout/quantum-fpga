library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Multiply_By_Scalar_Then_Add_High is
    Port (
        A : in  cvectorHigh;   -- Input complex vector 1
        B : in  cvectorHigh;   -- Input complex vector 2
        C : in  cfixedHigh;    -- Complex scalar multiplier
        Result : out cvectorHigh  -- Output complex vector (C*A + B)
    );
end Multiply_By_Scalar_Then_Add_High;

architecture Concurrent of Multiply_By_Scalar_Then_Add_High is
    -- Declare components
    component Multiply_Column_By_Scalar_High is
        Port (
            constComplex : in  cfixedHigh;
            rowVector    : in  cvectorHigh;
            outputVector : out cvectorHigh
        );
    end component;

    component Add_Vectors_Element_Wise_High is
        Port (
            a : in  cvectorHigh;
            b : in  cvectorHigh;
            c : out cvectorHigh
        );
    end component;

    -- Internal signal for intermediate result
    signal c_times_A : cvectorHigh;

begin
    -- Stage 1: Multiply C * A
    Multiply_Stage_High: Multiply_Column_By_Scalar_High
        port map (
            constComplex => C,
            rowVector    => A,
            outputVector => c_times_A
        );

    -- Stage 2: Add (C*A) + B
    Add_Stage_High: Add_Vectors_Element_Wise_High
        port map (
            a => c_times_A,
            b => B,
            c => Result
        );

end architecture Concurrent;
