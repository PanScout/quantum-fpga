library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

entity matrix_by_vector_multiplication is
    Port (
        A      : in  cmatrix;    -- Input complex matrix
        V      : in  cvector;    -- Input complex vector
        Result : out cvector     -- Output complex vector (A � V)
    );
end matrix_by_vector_multiplication;

architecture Concurrent of matrix_by_vector_multiplication is
    -- Declare component for vector scaling and addition
    component multiply_by_scalar_then_add is
        Port (
            A      : in  cvector;
            B      : in  cvector;
            C      : in  csfixed36;
            Result : out cvector
        );
    end component;

    -- Array for intermediate accumulation results
    type sum_array is array (0 to dimension) of cvector;
    signal sum : sum_array := (
        others => (others => (re => (others => '0'), im => (others => '0')))
    );

begin
    -- Generate processing chain for each matrix column
    gen_column_processing : for j in 0 to dimension-1 generate
        signal column_vector : cvector;
    begin
        -- Extract j-th column from matrix
        gen_column_extraction : for i in 0 to dimension-1 generate
            column_vector(i) <= A(i)(j);  -- A(row)(column)
        end generate gen_column_extraction;

        -- Multiply column by vector element and accumulate
        MTA_stage : multiply_by_scalar_then_add
            port map (
                A      => column_vector,  -- Current matrix column
                B      => sum(j),         -- Previous accumulation
                C      => V(j),           -- Vector element
                Result => sum(j+1)        -- New accumulation
            );
    end generate gen_column_processing;

    -- Connect final result
    Result <= sum(dimension);
end architecture Concurrent;
