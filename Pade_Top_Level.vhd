library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Pade_Top_Level is
    Port (
        t      : in  fixedHigh;
        output : out cmatrix
    );
end Pade_Top_Level;

architecture Behavioral of Pade_Top_Level is

    -- Declare a constant Hamiltonian of type cmatrixHigh.
    constant Hamiltonian : cmatrixHigh := (
        others => (others => ( re => to_sfixed(0, fixedHigh'high, fixedHigh'low),
                                im => to_sfixed(0, fixedHigh'high, fixedHigh'low) ))
    );

    component Insert_Imaginary_Time_Into_CMatrix
    Port (
        t : in  cfixed;       -- Input scalar for second multiplication
        C_out     : out cmatrixHigh    -- Final output matrix in high precision
    ); 
    end component Insert_Imaginary_Time_Into_CMatrix;

    component Calculate_Norm_And_Compare 
    port (
        -- Input matrix: dimension = numBasisStates × numBasisStates (from qTypes)
        A       : in  cmatrixHigh;
        
        -- Output: '1' if THETA > infinityNorm(A), else '0'
        isBelow : out std_logic;
	InfinityNormOut : out fixedHigh
    );
    end component Calculate_Norm_And_Compare;

    component One_to_Two_Demux_CMatrixHigh 
    Port (
        data_in : in  cmatrixHigh;
        sel     : in  std_logic;
        out0    : out cmatrixHigh;
        out1    : out cmatrixHigh
    );
    end component One_to_Two_Demux_CMatrixHigh;

    component Generate_Scaling_Factor is
    Port (
        input  : in  cfixedHigh;
        S      : out cfixedHigh
    );
    end component Generate_Scaling_Factor;

    component Scale_CMatrixHigh_Down 
    port (
        Input_Matrix  : in  cmatrixHigh;
        Shift_Amount  : in  fixedHigh; -- Interpreted as signed shift value
        Output_Matrix : out cmatrixHigh
    );
    end component Scale_CMatrixHigh_Down;

    component Pade_Denominator 
    Port (
        B : in  cmatrixHigh;
        P : out cmatrixHigh
    );
    end component Pade_Denominator;

    component Pade_Numerator 
    Port (
        B : in  cmatrixHigh;
        P : out cmatrixHigh
    );
    end component Pade_Numerator;

    component Matrix_Inversion 
    Port (
        input_matrix  : in  cmatrixHigh;
        output_matrix : out cmatrixHigh
    );
    end component Matrix_Inversion;

    component Matrix_By_Matrix_Multiplication_High 
    Port (
        A : in  cmatrixHigh;    -- First input matrix (M x N)
        B : in  cmatrixHigh;    -- Second input matrix (N x P)
        C : out cmatrixHigh     -- Output matrix (M x P)
    );
    end component Matrix_By_Matrix_Multiplication_High;

    component Scale_CMatrixHigh_Up 
    Port (
        input_matrix   : in  cmatrixHigh;
        output_matrix  : out cmatrixHigh;
        scale_factor   : in  cfixedHigh   -- Added scaling input
    );
    end component Scale_CMatrixHigh_Up;


begin
    -- No additional functionality is defined.
    
    -- (Optional) You may drive the output to a default value if required.
    -- For example:
    -- output <= toCmatrix(Hamiltonian);

    signal: IHTtoNormAndCompareandD1 cmatrixHigh;
    signal: TorF std_logic;
    signal: MatrixNorm fixedHigh;
    signal: s fixedHigh;
    -- ETC...


    IHT: Insert_Imaginary_Time_Into_CMatrix port map();
    Norm_And_Compare: Calculate_Norm_And_Compare port map();
    D1: One_to_Two_Demux_CMatrixHigh port map();
    D2: One_to_Two_Demux_CMatrixHigh port map();
    D3: One_to_Two_Demux_CMatrixHigh port map();
    Gen_Scaling_Factor: Generate_Scaling_Factor port map();
    Scale_Down: Scale_CMatrixHigh_Down port map();
    P_num: Pade_Numerator port map();
    P_den: Pade_Denominator port map();
    Invert: Matrix_Inversion port map();
    MULT: Matrix_By_Matrix_Multiplication_High port map();
    Scale_Up: Scale_CMatrixHigh_Up port map();


    

end Behavioral;
