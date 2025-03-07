library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed.ALL;
use work.qTypes.ALL;

entity Matrix_By_Vector_Multiplication_High is
    Port (
        A      : in  cmatrixHigh;    -- Input complex matrix
        V      : in  cvectorHigh;    -- Input complex vector
        Result : out cvectorHigh     -- Output complex vector (A � V)
    );
end Matrix_By_Vector_Multiplication_High;

architecture Concurrent of Matrix_By_Vector_Multiplication_High is
    -- Declare component for vector scaling and addition
    component Multiply_By_Scalar_Then_Add_High is
        Port (
            A      : in  cvectorHigh;
            B      : in  cvectorHigh;
            C      : in  cfixedHigh;
            Result : out cvectorHigh
        );
    end component;

    -- Array for intermediate accumulation results
    type sum_array is array (0 to numBasisStates) of cvectorHigh;
    signal sum : sum_array := (
        others => (others => (re => (others => '0'), im => (others => '0')))
    );

begin
    -- Generate processing chain for each matrix column
    gen_column_processing : for j in 0 to numBasisStates-1 generate
        signal column_vector : cvectorHigh;
    begin
        -- Extract j-th column from matrix
        gen_column_extraction : for i in 0 to numBasisStates-1 generate
            column_vector(i) <= A(i)(j);  -- A(row)(column)
        end generate gen_column_extraction;

        -- Multiply column by vector element and accumulate
        MTA_stage : Multiply_By_Scalar_Then_Add_High
            port map (
                A      => column_vector,  -- Current matrix column
                B      => sum(j),         -- Previous accumulation
                C      => V(j),           -- Vector element
                Result => sum(j+1)        -- New accumulation
            );
    end generate gen_column_processing;

    -- Connect final result
    Result <= sum(numBasisStates);
end architecture Concurrent;
