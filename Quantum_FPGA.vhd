
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Quantum_FPGA is
    Port (
        clk    : in std_logic;
        reset  : in std_logic;
	H      : in cmatrix;
	psi    : in cvector;
        t      : in  cfixed;

	loadTime, loadHamiltonian, loadPsi: std_logic; -- load signals
	tEnable : std_logic; --tri state enable
	done   : out std_logic;
        output : out cvector
    );
end Quantum_FPGA;

architecture Behavioral of Quantum_FPGA is

component Pade_Top_Level
    Port (
        clk    : in std_logic;
        reset  : in std_logic;
	H      : in cmatrix;
        t      : in  cfixed;
	padeDone : out std_logic;
        output : out cmatrix
    );
end component;

component Register_cmatrix
    Port (
        clk      : in std_logic;
        rst      : in std_logic;
        load     : in std_logic;
        data_in  : in cmatrix;
        data_out : out cmatrix
    );
end component;

component Register_cvector
    Port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        load     : in  std_logic;
        data_in  : in  cvector;
        data_out : out cvector
    );
end component;

component Register_cfixed
    Port (
        clk   : in std_logic;
        reset : in std_logic;
        load  : in std_logic;
        d     : in cfixed;
        q     : out cfixed
    );
end component;

component triStateBuffer_cmatrix
    Port (
        data_in : in  cmatrix;
        enable  : in  std_logic;
        data_out: out cmatrix
    );
end component;

component TristateBuffer_cvector
    Port (
        data_in : in  cvector;
        enable  : in  std_logic;
        data_out: out cvector
    );
end component;

component Matrix_By_Vector_Multiplication 
    Port (
        A      : in  cmatrix;    -- Input complex matrix
        V      : in  cvector;    -- Input complex vector
        Result : out cvector     -- Output complex vector (A � V)
    );
end component;

component Probability_Cvector 
    Port (
        cv_in   : in  cvector;  -- Input quantum state vector (complex amplitudes)
        prob_out: out cvector   -- Output vector with probabilities in the real part
    );
end component;

signal timeOut : cfixed;
signal HamiltonianOut : cmatrix;
signal psiOut, UxPsiOut, stateOut, probabilities : cvector;
signal padeOutput, padeBuffOut : cmatrix;
signal padeDone : std_logic;

begin

regt : Register_cfixed port map(clk => clk, reset => reset, load => loadTime, d => t, q => timeOut); 
regHam : Register_cmatrix port map(clk => clk, rst => reset, load => loadHamiltonian, data_in => H, data_out => HamiltonianOut); 
regPsi : Register_cvector port map(clk => clk, rst => reset, load => loadPsi, data_in => psi, data_out => psiOut); 
pade: Pade_Top_Level port map(clk => clk, reset => reset, H => H, t => t, padeDone => padeDone, output => padeOutput);
padeBuff: triStateBuffer_cmatrix port map(data_in => padeOutput, enable => tEnable, data_out => padeBuffOut);
mult: Matrix_By_Vector_Multiplication port map(A => padeBuffOut, V => psiOut, Result => UxPsiOut);
stateBuff: TristateBuffer_cvector port map(data_in => UxPsiOut, enable => padeDone, data_out => stateOut);
prob: Probability_Cvector  port map(cv_in => stateOut, prob_out => probabilities);

done <= padeDone;
output <= probabilities;

end Behavioral;
