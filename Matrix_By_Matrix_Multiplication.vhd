library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed.ALL;
use work.qTypes.ALL;

entity Matrix_By_Matrix_Multiplication is
    Port (
        A : in  cmatrix;    -- First input matrix (M x N)
        B : in  cmatrix;    -- Second input matrix (N x P)
        C : out cmatrix     -- Output matrix (M x P)
    );
end Matrix_By_Matrix_Multiplication;

architecture Concurrent of Matrix_By_Matrix_Multiplication is
    component Matrix_By_Vector_Multiplication is
        Port (
            A      : in  cmatrix;
            V      : in  cvector;
            Result : out cvector
        );
    end component;

    -- Array to store B's columns as vectors
    type column_array is array (0 to numBasisStates-1) of cvector;

begin
    -- Generate a column processor for each column in matrix B
    gen_column_processors : for col_idx in 0 to numBasisStates-1 generate
        signal b_column : cvector;  -- Stores current column of B
        signal c_column : cvector;  -- Stores resulting column of C
    begin
        -- Extract column from B (B is row-major)
        gen_column_extraction : for row_idx in 0 to numBasisStates-1 generate
        begin
            -- Convert row-major to column vector: B(row)(col) => b_column(row)
            b_column(row_idx) <= B(row_idx)(col_idx);
        end generate gen_column_extraction;

        -- Multiply matrix A with current column of B
        VectorMult : Matrix_By_Vector_Multiplication
            port map (
                A      => A,
                V      => b_column,
                Result => c_column
            );

        -- Distribute result column to output matrix C
        gen_column_distribution : for row_idx in 0 to numBasisStates-1 generate
        begin
            -- Assign to C's row-major format: C(row)(col) <= c_column(row)
            C(row_idx)(col_idx) <= c_column(row_idx);
        end generate gen_column_distribution;
    end generate gen_column_processors;

end architecture Concurrent;
