library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL; -- Assuming cfixed64, cmatrix, cvector are defined here
use work.qTypes.all;    -- Or potentially definitions are split between these two

entity Quantum_FPGA is
    Port (
        clk    : in std_logic;     -- Clock for sequential sub-components
        reset  : in std_logic;     -- Reset for sequential sub-components
        H      : in cmatrix;       -- Input Hamiltonian (passed directly)
        psi    : in cvector;       -- Input state vector (passed directly)
        t      : in cfixed64;      -- Input time value (passed directly)
        done   : out std_logic;    -- Calculation completion signal (from Pade)
        output : out cvector       -- Result of U(t) * psi
    );
end Quantum_FPGA;

architecture Behavioral of Quantum_FPGA is

    -- Component: Pade Approximation Calculation
    component Pade_Top_Level
        Port (
            clk    : in std_logic;
            reset  : in std_logic;
            H      : in cmatrix;
            t      : in cfixed64;
            padeDone : out std_logic; -- Signal indicating Pade calculation is finished
            output : out cmatrix      -- Output of Pade approximation, U(t) = exp(-iHt)
        );
    end component;

    -- Component: Matrix-Vector Multiplication
    component Matrix_By_Vector_Multiplication
        Port (
            -- Note: This component might need clk/reset if it's pipelined internally
            -- Assuming it's combinatorial or its clocking is handled internally
            A      : in  cmatrix;    -- Input complex matrix (U(t))
            V      : in  cvector;    -- Input complex vector (psi)
            Result : out cvector     -- Output complex vector (A * V)
        );
    end component;

    -- Internal signals to connect components
    signal pade_output_matrix : cmatrix;   -- Output of the Pade component U(t)
    signal pade_done_signal   : std_logic; -- Done signal from the Pade component

    -- No internal registers or buffers needed

begin

    -- Instantiate the Pade Approximation component
    -- Inputs H and t are directly connected from the entity's ports.
    pade_inst : Pade_Top_Level
        port map (
            clk      => clk,
            reset    => reset,
            H        => H,              -- Pass H directly
            t        => t,              -- Pass t directly
            padeDone => pade_done_signal, -- Capture the done signal
            output   => pade_output_matrix -- Capture the resulting U(t) matrix
        );

    -- Instantiate the Matrix-Vector Multiplication component
    -- Input A comes from the Pade output, input V comes directly from entity port psi.
    mult_inst : Matrix_By_Vector_Multiplication
        port map (
            -- Pass clk/reset if the multiplier component requires them
            A      => pade_output_matrix, -- Use the calculated U(t)
            V      => psi,                -- Use the input psi directly
            Result => output              -- Connect result directly to entity output
        );

    -- Connect the done signal from the Pade component to the entity's done output
    done <= pade_done_signal;

    -- The output port is directly driven by the Result of mult_inst.

end Behavioral;
