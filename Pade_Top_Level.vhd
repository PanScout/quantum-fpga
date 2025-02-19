library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Pade_Top_Level is
    Port (
        clk    : in std_logic;
        reset  : in std_logic;
        t      : in  cfixed;
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
	InfinityNormOut : out cfixedHigh
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

    component Two_to_One_Mux_CMatrixHigh
    Port (
        in0      : in  cmatrixHigh;  -- Input 0
        in1      : in  cmatrixHigh;  -- Input 1
        sel      : in  std_logic;    -- Selector
        data_out : out cmatrixHigh   -- Output
    );
    end component Two_to_One_Mux_CMatrixHigh;

    component Generate_Scaling_Factor
    Port (
        input  : in  cfixedHigh;
        S      : out cfixedHigh
    );
    end component Generate_Scaling_Factor;

    component Scale_CMatrixHigh_Down 
    port (
        Input_Matrix  : in  cmatrixHigh;
        Shift_Amount  : in  cfixedHigh; -- Interpreted as signed shift value
        Output_Matrix : out cmatrixHigh
    );
    end component Scale_CMatrixHigh_Down;

    component Scale_CMatrixHigh_Up
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        B      : in  cmatrixHigh;
        S      : in  cfixedHigh;
        Result : out cmatrixHigh;
        done   : out std_logic
    );
    end component Scale_CMatrixHigh_Up;

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
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        input_matrix    : in  cmatrixHigh;
        output_matrix   : out cmatrixHigh;
        done            : out std_logic
    );
    end component Matrix_Inversion;

    component Register_cmatrixHigh
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        load     : in  std_logic;
        data_in  : in  cmatrixHigh;
        data_out : out cmatrixHigh
    );
    end component;

    component Matrix_By_Matrix_Multiplication_High 
    Port (
        A : in  cmatrixHigh;    -- First input matrix (M x N)
        B : in  cmatrixHigh;    -- Second input matrix (N x P)
        C : out cmatrixHigh     -- Output matrix (M x P)
    );
    end component Matrix_By_Matrix_Multiplication_High;

    -- No additional functionality is defined.
    
    -- (Optional) You may drive the output to a default value if required.
    -- For example:
    -- output <= toCmatrix(Hamiltonian);

    signal IHTtoNormAndCompareandD1 : cmatrixHigh; -- output of Insert_Imaginary_Time_Into_CMatrix
    signal TorF : std_logic; -- T/F output of Calculate_Norm_And_Compare
    signal InfNormOut : cfixedHigh;     
    signal IHTtoScalar : cmatrixHigh;
    signal IHTdirect : cmatrixHigh;
    signal ScalingFactorOut : cfixedHigh;
    signal ScaleDownOut : cmatrixHigh;  
    signal Mux2Out : cmatrixHigh;
    signal PNumeratorOut : cmatrixHigh;
    signal PDenominatorOut : cmatrixHigh;
    signal InvOut : cmatrixHigh;
    signal MatrixMultOut : cmatrixHigh;
    signal MatriPowIn : cmatrixHigh;
    signal Mux4In : cmatrixHigh;
    signal ScaleUpOut : cmatrixHigh;
    signal done : std_logic;
    signal Mux4Out : cmatrixHigh;
    signal reg1Out, reg2Out : cmatrixHigh;
    -- ETC...

begin
    IHT: Insert_Imaginary_Time_Into_CMatrix port map(t=> t, C_out => IHTtoNormAndCompareandD1);
    Norm_And_Compare: Calculate_Norm_And_Compare port map(A => IHTtoNormAndCompareandD1, isBelow => TorF, infinityNormOut => InfNormOut);
    D1: One_to_Two_Demux_CMatrixHigh port map(data_in => IHTtoNormAndCompareandD1, sel => TorF, out0 => IHTtoScalar, out1 => IHTdirect);
    Gen_Scaling_Factor: Generate_Scaling_Factor port map(input => InfNormOut, S => ScalingFactorOut);
    Scale_Down: Scale_CMatrixHigh_Down port map(Input_Matrix => IHTtoScalar, Shift_Amount => ScalingFactorOut, Output_Matrix => ScaleDownOut);
    D2: Two_to_One_Mux_CMatrixHigh port map(in0 => IHTdirect, in1 => ScaleDownOut, sel => TorF, data_out => Mux2Out);
    P_num: Pade_Numerator port map(B => Mux2Out, P => PNumeratorOut);
    P_den: Pade_Denominator port map(B => Mux2Out, P => PDenominatorOut);
    reg1: Register_cmatrixHigh port map(clk => clk, rst => reset, load => '1', data_in => PDenominatorOut, data_out => reg1Out);
    reg2: Register_cmatrixHigh port map(clk => clk, rst => reset, load => '1', data_in => reg1Out, data_out => reg2Out);
    Invert: Matrix_Inversion port map(clk => clk, rst => reset, start => '1',input_matrix => reg2Out, output_matrix => InvOut);
    MULT: Matrix_By_Matrix_Multiplication_High port map(A => PNumeratorOut, B => InvOut, C => MatrixMultOut);
    D3: One_to_Two_Demux_CMatrixHigh port map(data_in => MatrixMultOut, sel => TorF, out0 => Mux4In, out1 => MatriPowIn);
    Scale_Up: Scale_CMatrixHigh_Up port map(clk => clk, reset => reset, B => MatriPowIn, S => ScalingFactorOut, Result => ScaleUpOut, done => done);
    D4: Two_to_One_Mux_CMatrixHigh port map(in0 => Mux4In, in1 => ScaleUpOut, sel => TorF, data_out => Mux4Out);
    
    output <= toCmatrix(Mux4Out);


    

end Behavioral;
