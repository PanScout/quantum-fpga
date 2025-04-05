library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.fixed_pkg.ALL; -- For sfixed, to_sfixed, vecSize (assumed)
use work.qTypes.all;    -- For cmatrix, cvector, cfixed64, fixed64 bounds (assumed)

-- Testbench entity (no ports)
entity Quantum_Time_Evolution_tb is
end Quantum_Time_Evolution_tb;

architecture Behavioral of Quantum_Time_Evolution_tb is

    -- Component Declaration for the Device Under Test (DUT)
    component Quantum_Time_Evolution is
        port (
            clk                 : in  std_logic;
            reset               : in  std_logic;
            psiAssemblerDone    : in  std_logic;
            matrixAssemblerDone : in  std_logic;
            start_evolution     : in  std_logic;
            H_in                : in  cmatrix;
            psi_in              : in  cvector;
            output_state        : out cvector;
            output_valid        : out std_logic;
            current_t_index     : out integer;
            evolution_complete  : out std_logic
        );
    end component;

    -- Constants for the testbench
    constant CLK_PERIOD : time := 10 ns; -- Example clock period
    -- ASSUMPTION: vecSize constant defines matrix/vector dimension (e.g., 2 for 2x2)
    -- If vecSize is not defined in packages, define it here:
    -- constant N : integer := 2;
    -- Use vecSize directly if defined in packages:
    constant N : integer := numComplexNumbersinVector;

    -- Fixed-point constants (using assumed bounds from DUT)
    -- Ensure these bounds match your actual cfixed64 definition
    constant FP_HIGH : integer := fixed64'high;
    constant FP_LOW  : integer := fixed64'low;
    constant CFIXED_ZERO : cfixed64 := (re => to_sfixed(0.0, FP_HIGH, FP_LOW), im => to_sfixed(0.0, FP_HIGH, FP_LOW));
    constant CFIXED_ONE  : cfixed64 := (re => to_sfixed(1.0, FP_HIGH, FP_LOW), im => to_sfixed(0.0, FP_HIGH, FP_LOW));
    constant CFIXED_HALF : cfixed64 := (re => to_sfixed(0.5, FP_HIGH, FP_LOW), im => to_sfixed(0.0, FP_HIGH, FP_LOW));

    -- Signals to connect to DUT ports
    -- Clock
    signal tb_clk   : std_logic := '0';
    -- Reset
    signal tb_reset : std_logic := '1'; -- Start in reset
    -- Control Signals
    signal tb_psi_done : std_logic := '0';
    signal tb_mat_done : std_logic := '0';
    signal tb_start    : std_logic := '0';
    -- DUT Inputs (Data)
    signal tb_H   : cmatrix; -- Initialized in stimulus process
    signal tb_psi : cvector; -- Initialized in stimulus process
    -- DUT Outputs (Monitored)
    signal tb_output_state : cvector;
    signal tb_output_valid : std_logic;
    signal tb_current_t_index : integer;
    signal tb_evolution_complete : std_logic;

begin

    -- Instantiate the Device Under Test (DUT)
    dut_inst : Quantum_Time_Evolution
        port map (
            clk                 => tb_clk,
            reset               => tb_reset,
            psiAssemblerDone    => tb_psi_done,
            matrixAssemblerDone => tb_mat_done,
            start_evolution     => tb_start,
            H_in                => tb_H,
            psi_in              => tb_psi,
            output_state        => tb_output_state,
            output_valid        => tb_output_valid,
            current_t_index     => tb_current_t_index,
            evolution_complete  => tb_evolution_complete
        );

    -- Clock Generation Process
    clk_process : process
    begin
        tb_clk <= '0';
        wait for CLK_PERIOD / 2;
        tb_clk <= '1';
        wait for CLK_PERIOD / 2;
        -- Optional: Stop clock after completion to save simulation time
        if tb_evolution_complete = '1' then
            wait;
        end if;
    end process clk_process;

    -- Stimulus Generation Process
    stimulus_process : process
    begin
        report "Starting Quantum_Time_Evolution Testbench";

        -- 1. Initialize Input Data (Identity Matrix for H, 0.5 vector for psi)
        report "Initializing H (Identity) and Psi (0.5 vector)...";
        -- Initialize H to Identity Matrix (size N x N)
        for i in 0 to N-1 loop
            for j in 0 to N-1 loop
                if i = j then
                    tb_H(i)(j) <= CFIXED_ONE;
                else
                    tb_H(i)(j) <= CFIXED_ZERO;
                end if;
            end loop;
        end loop;

        -- Initialize psi to a vector of 0.5 (size N)
        for i in 0 to N-1 loop
            tb_psi(i) <= CFIXED_HALF;
        end loop;

        -- 2. Apply Reset Sequence
        tb_reset <= '1';
        tb_psi_done <= '0';
        tb_mat_done <= '0';
        tb_start <= '0';
        report "Applying Reset...";
        wait for CLK_PERIOD * 3;
        tb_reset <= '0';
        report "Releasing Reset.";
        wait for CLK_PERIOD;

        -- 3. Signal Input Data Ready
        report "Signalling inputs ready (psiAssemblerDone, matrixAssemblerDone)...";
        tb_psi_done <= '1';
        tb_mat_done <= '1';
        wait for CLK_PERIOD;

        -- 4. Assert Start Signal
        report "Asserting start_evolution...";
        tb_start <= '1';
        wait for CLK_PERIOD;
        tb_start <= '0'; -- Deassert start (assuming it's level or edge sensitive)
        report "Start signal pulsed.";

        -- 5. Wait for completion
        report "Waiting for evolution to complete...";
        wait until tb_evolution_complete = '1';
        wait for CLK_PERIOD * 2; -- Wait a couple of cycles after completion detected

        report "Evolution complete signal received. Testbench finished.";

        -- Stop simulation using VHDL-2008 standard environment
        std.env.finish;
        -- Alternatively, for older simulators:
        -- assert false report "Simulation Finished" severity failure;

        wait; -- End the process

    end process stimulus_process;

    -- Optional: Monitor Process to report outputs when valid
    monitor_process : process(tb_clk)
    begin
        if rising_edge(tb_clk) then
            if tb_output_valid = '1' then
                report "Output Valid! t_index = " & integer'image(tb_current_t_index);
                -- You can add more detailed checks or reports for tb_output_state here.
                -- This might require functions to convert cfixed64/sfixed to string,
                -- which are often simulator-specific or need to be custom-written.
                -- Example (if to_string exists for the real part):
                -- report "  Output State(0).re = " & to_string(tb_output_state(0).re);
            end if;

            -- Optional: Check if evolution_complete goes high
            if tb_evolution_complete = '1' and tb_evolution_complete'delayed(CLK_PERIOD) = '0' then
                 report "Evolution Complete signal asserted.";
            end if;
        end if;
    end process monitor_process;

end Behavioral;
