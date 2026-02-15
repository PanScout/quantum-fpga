library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.fixed64.ALL;
use work.qTypes.all;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity Pade_Top_Level is
    Port (
        clk    : in std_logic;
        reset  : in std_logic;
		  H      : in cmatrix;
        t      : in  cfixed64;
	padeDone : out std_logic;
        output : out cmatrix
    );
end Pade_Top_Level;

architecture Behavioral of Pade_Top_Level is

    -- Declare a constant Hamiltonian of type cmatrix.
constant Hamiltonian : cmatrix := (
    others => (others => (
        re => (others => '0'),
        im => (others => '0')
    ))
);

    component Insert_Imaginary_Time_Into_CMatrix
    Port (
        t : in cfixed64;       -- Input scalar for second multiplication
		  H : in cmatrix;
        C_out     : out cmatrix  
    ); 
    end component Insert_Imaginary_Time_Into_CMatrix;

    component Calculate_Norm_And_Compare 
    port (
        -- Input matrix: dimension = dimension   dimension (from qTypes)
        A       : in  cmatrix;
        
        -- Output: '1' if THETA > infinityNorm(A), else '0'
        isBelow : out std_logic;
	InfinityNormOut : out cfixed64
    );
    end component Calculate_Norm_And_Compare;

    component Generate_Scaling_Factor
    Port (
        input  : in  cfixed64;
        S      : out cfixed64
    );
    end component Generate_Scaling_Factor;

    component Scale_CMatrix_Down 
    port (
        Input_Matrix  : in  cmatrix;
        Shift_Amount  : in  cfixed64; -- Interpreted as signed shift value
        Output_Matrix : out cmatrix
    );
    end component Scale_CMatrix_Down;

    component Scale_CMatrix_Up
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
	start : in std_logic;
        B      : in  cmatrix;
        S      : in  cfixed64;
        Result : out cmatrix;
        done   : out std_logic
    );
    end component Scale_CMatrix_Up;

    component padeDenominator
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        B     : in  cmatrix;
        P     : out cmatrix;
        done  : out std_logic
    );
    end component;

    component padeNumerator
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        B     : in  cmatrix;
        P     : out cmatrix;
        done  : out std_logic
    );
    end component;

    component Matrix_Inversion 
    Port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        input_matrix    : in  cmatrix;
        output_matrix   : out cmatrix;
        done            : out std_logic
    );
    end component Matrix_Inversion;

    component Matrix_By_Matrix_Multiplication 
    Port (
        A : in  cmatrix;    -- First input matrix (M x N)
        B : in  cmatrix;    -- Second input matrix (N x P)
        C : out cmatrix     -- Output matrix (M x P)
    );
    end component Matrix_By_Matrix_Multiplication;

    component Register_std_logic
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
	load  : in std_logic;
        d     : in  std_logic;
        q     : out std_logic
    );
    end component;

    component TriStateBuffer_std_logic 
    Port(
        clk        : in  std_logic;
        rst        : in  std_logic;
        out_signal : out std_logic
    );
    end component;

    -- No additional functionality is defined.
    
    -- (Optional) You may drive the output to a default value if required.
    -- For example:
    -- output <= toCmatrix(Hamiltonian);

    signal IHTtoNormAndCompareandD1 : cmatrix; -- output of Insert_Imaginary_Time_Into_CMatrix
    signal TorF : std_logic; -- T/F output of Calculate_Norm_And_Compare
    signal InfNormOut : cfixed64;     
    signal IHTtoScalar : cmatrix;
    signal IHTdirect : cmatrix;
    signal ScalingFactorOut : cfixed64;
    signal ScaleDownOut : cmatrix;  
    signal Mux2Out : cmatrix;
    signal PNumeratorOut : cmatrix;
    signal PDenominatorOut : cmatrix;
    signal InvOut : cmatrix;
    signal MatrixMultOut : cmatrix;
    signal MatriPowIn : cmatrix;
    signal Mux4In : cmatrix;
    signal ScaleUpOut : cmatrix;
    signal done, matrixInvDone, regStdLogicOut, tBuffStart, PNumDone, PDenDone : std_logic;
    signal Mux4Out : cmatrix;
    signal reg1Out, reg2Out, tBuffOut : cmatrix;
    -- ETC...

begin
    IHT: Insert_Imaginary_Time_Into_CMatrix port map(t=> t, H => H, C_out => IHTtoNormAndCompareandD1);
    Norm_And_Compare: Calculate_Norm_And_Compare port map(A => IHTtoNormAndCompareandD1, isBelow => TorF, infinityNormOut => InfNormOut);
    Gen_Scaling_Factor: Generate_Scaling_Factor port map(input => InfNormOut, S => ScalingFactorOut);
    Scale_Down: Scale_CMatrix_Down port map(Input_Matrix => IHTtoNormAndCompareandD1, Shift_Amount => ScalingFactorOut, Output_Matrix => ScaleDownOut);
    P_num: padeNumerator port map(clk => clk, reset => reset, start => tBuffStart, B => ScaleDownOut, P => PNumeratorOut, done => PNumDone);
    P_den: padeDenominator port map(clk => clk, reset => reset, start => tBuffStart, B => ScaleDownOut, P => PDenominatorOut, done => PDenDone);
    tBuffS: triStateBuffer_std_logic port map(clk => clk, rst => reset, out_signal => tBuffStart);
    Invert: Matrix_Inversion port map(clk => clk, rst => reset, start => PDenDone ,input_matrix => PDenominatorOut, output_matrix => InvOut, done => matrixInvDone);
    MULT: Matrix_By_Matrix_Multiplication port map(A => PNumeratorOut, B => InvOut, C => MatrixMultOut);
    reg3: Register_std_logic port map(clk => clk, reset => reset, load => '1', d => matrixInvDone, q => regStdLogicOut); 
    Scale_Up: Scale_CMatrix_Up port map(clk => clk, reset => reset, start => regStdLogicOut, B => MatrixMultOut, S => ScalingFactorOut, Result => ScaleUpOut, done => padeDone);

    
    output <= ScaleUpOut;


    

end Behavioral;
