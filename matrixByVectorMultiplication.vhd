library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity matrixByVectorMultiplication is
    Port (
        A      : in  cmatrix;    -- Input complex matrix
        V      : in  cvector;    -- Input complex vector
        Result : out cvector     -- Output complex vector (A × V)
    );
end matrixByVectorMultiplication;

architecture Concurrent of matrixByVectorMultiplication is
    -- Declare component for vector scaling and addition
    component multiplyThenAddVectors is
        Port (
            A      : in  cvector;
            B      : in  cvector;
            C      : in  cfixed;
            Result : out cvector
        );
    end component;

    -- Array for intermediate accumulation results
    type sum_array is array (0 to numBasisStates) of cvector;
    signal sum : sum_array := (
        others => (others => (re => (others => '0'), im => (others => '0')))
    );

begin
    -- Generate processing chain for each matrix column
    gen_column_processing : for j in 0 to numBasisStates-1 generate
        signal column_vector : cvector;
    begin
        -- Extract j-th column from matrix
        gen_column_extraction : for i in 0 to numBasisStates-1 generate
            column_vector(i) <= A(i)(j);  -- A(row)(column)
        end generate gen_column_extraction;

        -- Multiply column by vector element and accumulate
        MTA_stage : multiplyThenAddVectors
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
