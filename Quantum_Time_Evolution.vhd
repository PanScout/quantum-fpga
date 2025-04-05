library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL; -- For sfixed, to_sfixed if used in T_VALUES
use work.qTypes.all;    -- For cmatrix, cvector, cfixed64

entity Quantum_Time_Evolution is
    port (
        clk                 : in  std_logic;
        reset               : in  std_logic;     -- Synchronous reset
        psiAssemblerDone    : in  std_logic;     -- Input Psi vector is ready
        matrixAssemblerDone : in  std_logic;     -- Input H matrix is ready
        start_evolution     : in  std_logic;     -- Signal to begin the 30-step evolution (when ready)
        H_in                : in  cmatrix;       -- Input Hamiltonian (stable after matrixAssemblerDone='1')
        psi_in              : in  cvector;       -- Input initial state vector (stable after psiAssemblerDone='1')

        output_state        : out cvector;       -- Output state for the current time step t(i)
        output_valid        : out std_logic;     -- High for one clock when output_state is valid for t(i)
        current_t_index     : out integer;       -- Index (0-29) of the time step whose result is on output_state
        evolution_complete  : out std_logic      -- High when all 30 steps are done
    );
end Quantum_Time_Evolution;

architecture Behavioral of Quantum_Time_Evolution is

    -- Component Declaration for the simplified worker module
    component Quantum_FPGA is
        Port (
            clk    : in std_logic;
            reset  : in std_logic;
            H      : in cmatrix;
            psi    : in cvector;
            t      : in cfixed64;
            done   : out std_logic;    -- Calculation completion signal
            output : out cvector       -- Result of U(t) * psi
        );
    end component;

    -- Define the number of time steps
    constant NUM_TIME_STEPS : integer := 30;

    -- Define an array type to hold the time steps
    type time_step_array is array (0 to NUM_TIME_STEPS - 1) of cfixed64;

    -- Define the actual time steps
    -- Using example values provided by the user
    -- Assumes 'fixed64' refers to the bounds defined in fixed_pkg/qTypes for cfixed64 elements
    constant T_VALUES : time_step_array := (
        0  => (re => to_sfixed(0.0,        fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)), -- Index 0
        1  => (re => to_sfixed(0.10833078, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)), -- Index 1
        2  => (re => to_sfixed(0.21666156, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        3  => (re => to_sfixed(0.32499234, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        4  => (re => to_sfixed(0.43332312, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        5  => (re => to_sfixed(0.54165391, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        6  => (re => to_sfixed(0.64998469, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        7  => (re => to_sfixed(0.75831547, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        8  => (re => to_sfixed(0.86664625, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        9  => (re => to_sfixed(0.97497703, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        10 => (re => to_sfixed(1.08330781, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        11 => (re => to_sfixed(1.19163859, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        12 => (re => to_sfixed(1.29996937, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        13 => (re => to_sfixed(1.40830016, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        14 => (re => to_sfixed(1.51663094, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        15 => (re => to_sfixed(1.62496172, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        16 => (re => to_sfixed(1.7332925,  fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        17 => (re => to_sfixed(1.84162328, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        18 => (re => to_sfixed(1.94995406, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        19 => (re => to_sfixed(2.05828484, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        20 => (re => to_sfixed(2.16661562, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        21 => (re => to_sfixed(2.2749464,  fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        22 => (re => to_sfixed(2.38327719, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        23 => (re => to_sfixed(2.49160797, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        24 => (re => to_sfixed(2.59993875, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        25 => (re => to_sfixed(2.70826953, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        26 => (re => to_sfixed(2.81660031, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        27 => (re => to_sfixed(2.92493109, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        28 => (re => to_sfixed(3.03326187, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
        29 => (re => to_sfixed(3.14159265, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)) -- Index 29 (Last)
        -- NOTE: Ensure fixed64'high and fixed64'low correctly reference the bounds defined in your packages.
    );

    -- State machine definition
    type state_type is (
        IDLE,               -- Waiting for inputs ready and start signal
        RUN_CALCULATION,    -- Running Quantum_FPGA_Simple for the current t_index
        CAPTURE_OUTPUT,     -- Capturing the result and pulsing output_valid
        FINISHED            -- All steps completed
    );
    signal current_state, next_state : state_type := IDLE;

    -- Counter for time steps (registered)
    signal t_index_reg : integer range 0 to NUM_TIME_STEPS := 0; -- Tracks the *next* index to compute
    signal t_index_out_reg : integer range 0 to NUM_TIME_STEPS - 1 := 0; -- Tracks index of *current output*

    -- Signals to connect to Quantum_FPGA_Simple
    signal qfpga_t      : cfixed64;
    signal qfpga_done   : std_logic;
    signal qfpga_output : cvector;
    signal qfpga_reset  : std_logic; -- Internal reset control for component

    -- Output registers
    signal output_state_reg : cvector;
    signal output_valid_reg : std_logic := '0';
    signal evolution_complete_reg : std_logic := '0';

begin

    -- Instantiate the simplified Quantum FPGA compute unit
    quantum_unit : Quantum_FPGA
        port map (
            clk     => clk,
            reset   => qfpga_reset,   -- Connect controlled reset
            H       => H_in,          -- Pass H directly
            psi     => psi_in,        -- Pass psi directly
            t       => qfpga_t,       -- Pass selected t value
            done    => qfpga_done,    -- Get done signal
            output  => qfpga_output   -- Get output vector
        );

    -- State Machine Logic - Combinational Part (Transitions and Controls)
    -- Added psiAssemblerDone and matrixAssemblerDone to sensitivity list and IDLE condition
    process(current_state, reset, psiAssemblerDone, matrixAssemblerDone, start_evolution, qfpga_done, t_index_reg)
    begin
        -- Default assignments
        next_state        <= current_state; -- Stay in current state unless changed
        qfpga_t           <= T_VALUES(t_index_reg); -- Select t based on *next* index to compute
        qfpga_reset       <= reset;         -- Pass external reset by default
        output_valid_reg  <= '0';           -- Default valid to low
        evolution_complete_reg <= '0';      -- Default complete to low

        case current_state is
            when IDLE =>
                qfpga_reset <= '1'; -- Hold component in reset while idle

                -- Check if inputs are ready AND start signal is asserted
                if reset = '0' and
                   psiAssemblerDone = '1' and
                   matrixAssemblerDone = '1' and
                   start_evolution = '1'
                then
                    if NUM_TIME_STEPS > 0 then -- Check if there are steps to run
                       next_state <= RUN_CALCULATION;
                       qfpga_reset <= '0'; -- Deassert reset to start calculation
                    else
                       next_state <= FINISHED; -- No steps, go directly to finished
                    end if;
                else
                    next_state <= IDLE; -- Stay idle if not ready or not started
                end if;

            when RUN_CALCULATION =>
                 qfpga_reset <= '0'; -- Ensure component is not in reset
                 qfpga_t <= T_VALUES(t_index_reg); -- Drive current t value
                if qfpga_done = '1' then
                    next_state <= CAPTURE_OUTPUT;
                else
                    next_state <= RUN_CALCULATION;
                end if;

            when CAPTURE_OUTPUT =>
                -- Output is captured in sequential process based on this state
                output_valid_reg <= '1'; -- Signal data is valid for one cycle
                if t_index_reg = NUM_TIME_STEPS - 1 then -- Was the last step just completed?
                    next_state <= FINISHED;
                else
                    -- Prepare for next calculation in the *next* cycle
                    next_state <= RUN_CALCULATION;
                end if;

            when FINISHED =>
                evolution_complete_reg <= '1'; -- Assert completion flag
                qfpga_reset <= '1';       -- Hold component in reset when finished
                next_state <= FINISHED;   -- Stay finished until reset or new start

        end case;

        -- Global reset overrides everything
        if reset = '1' then
            next_state <= IDLE;
            qfpga_reset <= '1';
        end if;

    end process;

    -- State Machine Logic - Sequential Part (Registers)
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= IDLE;
                t_index_reg <= 0;
                t_index_out_reg <= 0;
                -- Optional: Reset output state register if desired
                -- output_state_reg <= cvector_reset_value; -- Use an appropriate reset value for cvector type
            else
                -- Update state
                current_state <= next_state;

                -- Latch output and update index registers based on state transitions
                case current_state is
                    when RUN_CALCULATION =>
                        if next_state = CAPTURE_OUTPUT then
                            -- Calculation just finished for t_index_reg
                            output_state_reg <= qfpga_output;
                            t_index_out_reg  <= t_index_reg; -- Latch index corresponding to output
                        end if;

                    when CAPTURE_OUTPUT =>
                        if next_state = RUN_CALCULATION then
                            -- Moving to calculate the *next* index
                            t_index_reg <= t_index_reg + 1;
                        end if;
                        -- Note: If next_state is FINISHED, t_index_reg doesn't need to change

                    when IDLE =>
                        if next_state = RUN_CALCULATION then
                            t_index_reg <= 0; -- Start from the first index
                            t_index_out_reg <= 0; -- Reset output index as well
                        end if;

                    when others =>
                       null; -- No index changes in other states
                end case;

            end if; -- end reset check
        end if; -- end clock edge check
    end process;

    -- Drive Outputs
    output_state        <= output_state_reg;
    output_valid        <= output_valid_reg;         -- Driven by combinatorial block
    current_t_index     <= t_index_out_reg;       -- Output the index for the current valid data
    evolution_complete  <= evolution_complete_reg; -- Driven by combinatorial block

end Behavioral;