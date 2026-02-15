library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
use work.qTypes.all;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity pade_top_level is
    Port (
        clk    : in std_logic;
        reset  : in std_logic;
		  H      : in cmatrix;
        t      : in  csfixed36;
	padeDone : out std_logic;
        output : out cmatrix
    );
end pade_top_level;

architecture Behavioral of pade_top_level is

    -- Declare a constant Hamiltonian of type cmatrix.
constant Hamiltonian : cmatrix := (
    others => (others => (
        re => (others => '0'),
        im => (others => '0')
    ))
);

    component insert_imaginary_time_into_cmatrix
    Port (
        t : in csfixed36;       -- Input scalar for second multiplication
		  H : in cmatrix;
        C_out     : out cmatrix  
    ); 
    end component insert_imaginary_time_into_cmatrix;

    component calculate_norm_and_compare 
    port (
        -- Input matrix: dimension = dimension   dimension (from qTypes)
        A       : in  cmatrix;
        
        -- Output: '1' if THETA > infinityNorm(A), else '0'
        isBelow : out std_logic;
	InfinityNormOut : out csfixed36
    );
    end component calculate_norm_and_compare;

    component generate_scaling_factor
    Port (
        input  : in  csfixed36;
        S      : out csfixed36
    );
    end component generate_scaling_factor;

    component scale_cmatrix_down 
    port (
        Input_Matrix  : in  cmatrix;
        Shift_Amount  : in  csfixed36; -- Interpreted as signed shift value
        Output_Matrix : out cmatrix
    );
    end component scale_cmatrix_down;

    component repeated_matrix_squaring
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
	start : in std_logic;
        B      : in  cmatrix;
        S      : in  csfixed36;
        Result : out cmatrix;
        done   : out std_logic
    );
    end component repeated_matrix_squaring;

    component pade_denominator
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        B     : in  cmatrix;
        P     : out cmatrix;
        done  : out std_logic
    );
    end component;

    component pade_numerator
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        B     : in  cmatrix;
        P     : out cmatrix;
        done  : out std_logic
    );
    end component;

    component matrix_inversion 
    Port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        input_matrix    : in  cmatrix;
        output_matrix   : out cmatrix;
        done            : out std_logic
    );
    end component matrix_inversion;

    component matrix_by_matrix_multiplication 
    Port (
        A : in  cmatrix;    -- First input matrix (M x N)
        B : in  cmatrix;    -- Second input matrix (N x P)
        C : out cmatrix     -- Output matrix (M x P)
    );
    end component matrix_by_matrix_multiplication;

    component register_std_logic
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
	load  : in std_logic;
        data_in  : in  std_logic;
        data_out : out std_logic
    );
    end component;

    component delayed_pulse_generator 
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

    signal IHTtoNormAndCompareandD1 : cmatrix; -- output of insert_imaginary_time_into_cmatrix
    signal TorF : std_logic; -- T/F output of calculate_norm_and_compare
    signal InfNormOut : csfixed36;     
    signal IHTtoScalar : cmatrix;
    signal IHTdirect : cmatrix;
    signal ScalingFactorOut : csfixed36;
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
    IHT: insert_imaginary_time_into_cmatrix port map(t=> t, H => H, C_out => IHTtoNormAndCompareandD1);
    Norm_And_Compare: calculate_norm_and_compare port map(A => IHTtoNormAndCompareandD1, isBelow => TorF, infinityNormOut => InfNormOut);
    Gen_Scaling_Factor: generate_scaling_factor port map(input => InfNormOut, S => ScalingFactorOut);
    Scale_Down: scale_cmatrix_down port map(Input_Matrix => IHTtoNormAndCompareandD1, Shift_Amount => ScalingFactorOut, Output_Matrix => ScaleDownOut);
    P_num: pade_numerator port map(clk => clk, reset => reset, start => tBuffStart, B => ScaleDownOut, P => PNumeratorOut, done => PNumDone);
    P_den: pade_denominator port map(clk => clk, reset => reset, start => tBuffStart, B => ScaleDownOut, P => PDenominatorOut, done => PDenDone);
    tBuffS: delayed_pulse_generator port map(clk => clk, rst => reset, out_signal => tBuffStart);
    Invert: matrix_inversion port map(clk => clk, rst => reset, start => PDenDone ,input_matrix => PDenominatorOut, output_matrix => InvOut, done => matrixInvDone);
    MULT: matrix_by_matrix_multiplication port map(A => PNumeratorOut, B => InvOut, C => MatrixMultOut);
    reg3: register_std_logic port map(clk => clk, reset => reset, load => '1', data_in => matrixInvDone, data_out => regStdLogicOut); 
    Scale_Up: repeated_matrix_squaring port map(clk => clk, reset => reset, start => regStdLogicOut, B => MatrixMultOut, S => ScalingFactorOut, Result => ScaleUpOut, done => padeDone);

    
    output <= ScaleUpOut;


    

end Behavioral;
