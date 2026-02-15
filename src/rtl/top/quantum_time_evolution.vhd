library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL;  -- For sfixed conversion functions
use work.qTypes.all;     -- For cmatrix, cvector, csfixed36

entity quantum_time_evolution is
    port (
        clk                 : in  std_logic;
        reset               : in  std_logic;     -- Synchronous reset
        psiAssemblerDone    : in  std_logic;     -- Input: Psi vector is ready
        matrixAssemblerDone : in  std_logic;     -- Input: H matrix is ready
        start_evolution     : in  std_logic;     -- Begin the 30-step evolution when ready
        H_in                : in  cmatrix;       -- Input Hamiltonian (stable after matrixAssemblerDone = '1')
        psi_in              : in  cvector;       -- Input initial state vector (stable after psiAssemblerDone = '1')
    
        output_state        : out cvector;       -- Output state for the current time step t(i)
        output_valid        : out std_logic;     -- High for one clock when output_state is valid for t(i)
        current_t_index     : out integer;       -- Index (0?29) of the time step on output_state
        evolution_complete  : out std_logic      -- High when all 30 steps are done
    );
end quantum_time_evolution;

architecture Behavioral of quantum_time_evolution is

    -- Component Declaration for the simplified worker module
    component quantum_fpga is
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            H      : in  cmatrix;
            psi    : in  cvector;
            t      : in  csfixed36;
            done   : out std_logic;    -- Calculation completion signal (padeDone)
            output : out cvector       -- Result of U(t) * psi
        );
    end component;

    -- Define the number of time steps and an array type for these time values.
    constant NUM_TIME_STEPS : integer := 30;
    type time_step_array is array (0 to NUM_TIME_STEPS - 1) of csfixed36;
    constant T_VALUES : time_step_array := (
         0  => (re => to_sfixed(0.0,        sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         1  => (re => to_sfixed(0.10833078, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         2  => (re => to_sfixed(0.21666156, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         3  => (re => to_sfixed(0.32499234, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         4  => (re => to_sfixed(0.43332312, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         5  => (re => to_sfixed(0.54165391, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         6  => (re => to_sfixed(0.64998469, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         7  => (re => to_sfixed(0.75831547, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         8  => (re => to_sfixed(0.86664625, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         9  => (re => to_sfixed(0.97497703, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         10 => (re => to_sfixed(1.08330781, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         11 => (re => to_sfixed(1.19163859, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         12 => (re => to_sfixed(1.29996937, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         13 => (re => to_sfixed(1.40830016, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         14 => (re => to_sfixed(1.51663094, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         15 => (re => to_sfixed(1.62496172, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         16 => (re => to_sfixed(1.7332925,  sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         17 => (re => to_sfixed(1.84162328, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         18 => (re => to_sfixed(1.94995406, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         19 => (re => to_sfixed(2.05828484, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         20 => (re => to_sfixed(2.16661562, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         21 => (re => to_sfixed(2.2749464,  sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         22 => (re => to_sfixed(2.38327719, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         23 => (re => to_sfixed(2.49160797, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         24 => (re => to_sfixed(2.59993875, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         25 => (re => to_sfixed(2.70826953, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         26 => (re => to_sfixed(2.81660031, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         27 => (re => to_sfixed(2.92493109, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         28 => (re => to_sfixed(3.03326187, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low)),
         29 => (re => to_sfixed(3.14159265, sfixed36'high, sfixed36'low), im => to_sfixed(0.0,        sfixed36'high, sfixed36'low))
    );

    -- Define the state machine with an extra state for worker reset.
    type state_type is (
        IDLE,               -- Waiting for inputs & start signal
        RUN_CALCULATION,    -- Performing calculation for the current time value
        CAPTURE_OUTPUT,     -- Latching the result when qfpga_done is high
        RESET_WORKER,       -- Asserting qfpga_reset to reinitialize the worker
        FINISHED            -- All time steps completed
    );
    signal current_state, next_state : state_type := IDLE;

    -- Counters for time-step indexing.
    signal t_index_reg     : integer range 0 to NUM_TIME_STEPS := 0;
    signal t_index_out_reg : integer range 0 to NUM_TIME_STEPS - 1 := 0;

    -- Signals that connect to the quantum_fpga component.
    signal qfpga_t      : csfixed36;
    signal qfpga_done   : std_logic;
    signal qfpga_output : cvector;
    signal qfpga_reset  : std_logic;  -- Internal reset control for the worker

    -- Output registers.
    signal output_state_reg       : cvector;
    signal output_valid_reg       : std_logic := '0';
    signal evolution_complete_reg : std_logic := '0';

begin
    ----------------------------------------------------------------------------
    -- Instantiate the worker module (quantum_fpga)
    ----------------------------------------------------------------------------
    quantum_unit : quantum_fpga
        port map (
            clk    => clk,
            reset  => qfpga_reset,
            H      => H_in,
            psi    => psi_in,
            t      => qfpga_t,
            done   => qfpga_done,
            output => qfpga_output
        );

    ----------------------------------------------------------------------------
    -- Combinational Process: Determine next state, assign t value, and generate
    -- the appropriate worker reset signal.
    ----------------------------------------------------------------------------
    process(current_state, reset, psiAssemblerDone, matrixAssemblerDone, start_evolution, qfpga_done, t_index_reg)
    begin
        -- Default assignments:
        next_state            <= current_state;
        qfpga_t               <= T_VALUES(t_index_reg);
        output_valid_reg      <= '0';
        evolution_complete_reg<= '0';
        qfpga_reset           <= '0';

        case current_state is
            when IDLE =>
                qfpga_reset <= '1';  -- Hold the worker in reset while idle.
                if (reset = '0' and psiAssemblerDone = '1' and matrixAssemblerDone = '1' and start_evolution = '1') then
                    if NUM_TIME_STEPS > 0 then
                        next_state <= RUN_CALCULATION;
                        qfpga_reset <= '0';  -- Deassert reset to begin calculation.
                    else
                        next_state <= FINISHED;
                    end if;
                else
                    next_state <= IDLE;
                end if;

            when RUN_CALCULATION =>
                qfpga_reset <= '0';  -- Ensure the worker is active.
                qfpga_t <= T_VALUES(t_index_reg);
                if qfpga_done = '1' then
                    next_state <= CAPTURE_OUTPUT;
                else
                    next_state <= RUN_CALCULATION;
                end if;

            when CAPTURE_OUTPUT =>
                output_valid_reg <= '1';  -- Latch output valid for one clock cycle.
                next_state <= RESET_WORKER;  -- Then assert a reset pulse.

            when RESET_WORKER =>
                qfpga_reset <= '1';  -- Assert reset to reinitialize the worker.
                if t_index_reg = NUM_TIME_STEPS - 1 then
                    next_state <= FINISHED;
                else
                    next_state <= RUN_CALCULATION;
                end if;

            when FINISHED =>
                evolution_complete_reg <= '1';
                qfpga_reset <= '1';  -- Keep the worker reset after finishing.
                next_state <= FINISHED;

            when others =>
                next_state <= IDLE;
        end case;

        -- Global external reset overrides all.
        if reset = '1' then
            next_state <= IDLE;
            qfpga_reset <= '1';
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Sequential Process: Update state and manage time-step index counters.
    ----------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state    <= IDLE;
                t_index_reg      <= 0;
                t_index_out_reg  <= 0;
            else
                current_state <= next_state;
                case current_state is
                    when RUN_CALCULATION =>
                        if next_state = CAPTURE_OUTPUT then
                            output_state_reg <= qfpga_output;  -- Latch the output.
                            t_index_out_reg  <= t_index_reg;    -- Latch the index corresponding to this output.
                        end if;
                    when CAPTURE_OUTPUT =>
                        null; -- No index update here.
                    when RESET_WORKER =>
                        if next_state = RUN_CALCULATION then
                            t_index_reg <= t_index_reg + 1;  -- Move to the next time-step.
                        end if;
                    when IDLE =>
                        if next_state = RUN_CALCULATION then
                            t_index_reg     <= 0;
                            t_index_out_reg <= 0;
                        end if;
                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Drive top-level outputs.
    ----------------------------------------------------------------------------
    output_state       <= output_state_reg;
    output_valid       <= output_valid_reg;
    current_t_index    <= t_index_out_reg;
    evolution_complete <= evolution_complete_reg;

end Behavioral;

