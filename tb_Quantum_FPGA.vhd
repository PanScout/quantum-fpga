library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity tb_Quantum_FPGA is
end tb_Quantum_FPGA;

architecture sim of tb_Quantum_FPGA is

    -- Clock period constant
    constant clk_period : time := 20 ns;

    -- Signal declarations for the UUT
    signal clk             : std_logic := '0';
    signal reset           : std_logic := '0';
    signal H               : cmatrix;
    signal psi             : cvector;
    signal t               : cfixed;
    signal loadTime        : std_logic := '0';
    signal loadHamiltonian : std_logic := '0';
    signal loadPsi         : std_logic := '0';
    signal tEnable         : std_logic := '0';
    signal done            : std_logic;
    signal output          : cvector;

begin

    -----------------------------------------------------------------------------
    -- Clock Generation Process
    -----------------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -----------------------------------------------------------------------------
    -- Instantiate the Unit Under Test (Quantum_FPGA)
    -----------------------------------------------------------------------------
    uut: entity work.Quantum_FPGA
        port map (
            clk             => clk,
            reset           => reset,
            H               => H,
            psi             => psi,
            t               => t,
            loadTime        => loadTime,
            loadHamiltonian => loadHamiltonian,
            loadPsi         => loadPsi,
            tEnable         => tEnable,
            done            => done,
            output          => output
        );

    -----------------------------------------------------------------------------
    -- Stimulus Process
    -----------------------------------------------------------------------------
    stim_proc : process
    begin
        -- Initialize signals and hold reset active
        reset <= '1';
        loadTime <= '0';
        loadHamiltonian <= '0';
        loadPsi <= '0';
        tEnable <= '0';
        wait for 40 ns;

        -- Deassert reset to start simulation
        reset <= '0';
        wait for 20 ns;
        reset <= '1';

        -----------------------------------------------------------------------------
        -- Provide Input Stimuli
        -----------------------------------------------------------------------------
        -- Provide an Identity matrix for H (assuming a 2x2 matrix of complex numbers)
        -- Here each complex number is represented as a record with (real, imag).
        H <= ( ( ( to_cfixed(1.0, 16, 8), to_cfixed(0.0, 16, 8) ),
                 ( to_cfixed(0.0, 16, 8), to_cfixed(0.0, 16, 8) ) ),
               ( ( to_cfixed(0.0, 16, 8), to_cfixed(0.0, 16, 8) ),
                 ( to_cfixed(0.0, 16, 8), to_cfixed(1.0, 16, 8) ) ) );

        -- Provide a simple state vector for psi (2 elements)
        psi <= ( ( to_cfixed(1.0, 16, 8), to_cfixed(0.0, 16, 8) ),
                 ( to_cfixed(0.0, 16, 8), to_cfixed(0.0, 16, 8) ) );

        -- Provide a time value, t
        t <= to_cfixed(1.0, 16, 8);

        -- Pulse the load signals for one clock cycle to load the data into registers
        loadHamiltonian <= '1';
        loadPsi         <= '1';
        loadTime        <= '1';
        wait for clk_period;
        loadHamiltonian <= '0';
        loadPsi         <= '0';
        loadTime        <= '0';

        -- Enable the tri-state buffer for the Pade output
        tEnable <= '1';

        -- Wait until the Quantum_FPGA module asserts done
        wait until done = '1';
        wait for clk_period;

        -- Optionally display or check the output
        report "Output vector = " & cvector'image(output);

        -- End simulation after some time
        wait for 100 ns;
        assert false report "End of simulation" severity failure;
    end process;

end sim;

