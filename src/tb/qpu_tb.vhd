library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

use STD.TEXTIO.ALL;

entity qpu_tb is
end entity qpu_tb;

architecture sim of qpu_tb is

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;  -- 100 MHz
    constant SPI_HALF   : time := 100 ns; -- SPI clock half-period (5 MHz)
    constant SPI_SETUP  : time := 20 ns;  -- MOSI setup before SCLK rise

    -- Number of bits per SPI word
    constant NUM_BITS : integer := 72;

    -- DUT signals
    signal clk                    : std_logic := '0';
    signal reset                  : std_logic := '1';
    signal enable                 : std_logic := '0';
    signal SCLK                   : std_logic := '0';
    signal rx_matrix_SS           : std_logic := '1';
    signal rx_matrix_MOSI         : std_logic := '0';
    signal rx_matrix_spi_valid    : std_logic;
    signal rx_vector_SS           : std_logic := '1';
    signal rx_vector_MOSI         : std_logic := '0';
    signal rx_vector_spi_valid    : std_logic;
    signal tx_SS                  : std_logic := '1';
    signal MISO                   : std_logic;
    signal tx_spi_valid           : std_logic;
    signal assembler_done_led     : std_logic;
    signal vector_done_led        : std_logic;
    signal qte_start              : std_logic;
    signal qte_valid              : std_logic;
    signal evo_complete           : std_logic;
    signal psi_done_led           : std_logic;
    signal sclk_led               : std_logic;
    signal psi_matrix_assemble_done : std_logic;

    -- Simulation control
    signal sim_done : boolean := false;

    -- Fixed-point constants: sfixed(14 downto -21)
    -- 1.0  = 2^21 = 2097152 = 0x200000 -> 36-bit slv = "000000000000010" & "000000000000000000000"
    -- 0.0  = 0
    constant ONE_FP  : std_logic_vector(35 downto 0) := "000000000000010" & "000000000000000000000";
    constant ZERO_FP : std_logic_vector(35 downto 0) := (others => '0');

    -- SPI words (72 bits each): [real(71:36) | imag(35:0)]
    -- Pauli-X Hamiltonian: H = [[0, 1], [1, 0]]
    constant H00 : std_logic_vector(NUM_BITS-1 downto 0) := ZERO_FP & ZERO_FP;  -- 0+0i
    constant H01 : std_logic_vector(NUM_BITS-1 downto 0) := ONE_FP  & ZERO_FP;  -- 1+0i
    constant H10 : std_logic_vector(NUM_BITS-1 downto 0) := ONE_FP  & ZERO_FP;  -- 1+0i
    constant H11 : std_logic_vector(NUM_BITS-1 downto 0) := ZERO_FP & ZERO_FP;  -- 0+0i

    -- Initial state vector: psi = [1, 0]
    constant PSI0 : std_logic_vector(NUM_BITS-1 downto 0) := ONE_FP  & ZERO_FP;  -- 1+0i
    constant PSI1 : std_logic_vector(NUM_BITS-1 downto 0) := ZERO_FP & ZERO_FP;  -- 0+0i

    -- Storage for received results
    type result_array is array (0 to 59) of std_logic_vector(NUM_BITS-1 downto 0);
    signal rx_results : result_array := (others => (others => '0'));

    -- Convert a 72-bit std_logic_vector to an 18-character hex string
    function slv_to_hexstr(v : std_logic_vector(71 downto 0)) return string is
        variable result : string(1 to 18);
        variable nibble : std_logic_vector(3 downto 0);
        constant hex_chars : string(1 to 16) := "0123456789abcdef";
    begin
        for i in 0 to 17 loop
            nibble := v(71 - i*4 downto 68 - i*4);
            result(i+1) := hex_chars(to_integer(unsigned(nibble)) + 1);
        end loop;
        return result;
    end function;

begin

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2 when not sim_done else '0';

    -- DUT instantiation
    dut : entity work.qpu
        port map (
            clk                    => clk,
            reset                  => reset,
            enable                 => enable,
            SCLK                   => SCLK,
            rx_matrix_SS           => rx_matrix_SS,
            rx_matrix_MOSI         => rx_matrix_MOSI,
            rx_matrix_spi_valid    => rx_matrix_spi_valid,
            rx_vector_SS           => rx_vector_SS,
            rx_vector_MOSI         => rx_vector_MOSI,
            rx_vector_spi_valid    => rx_vector_spi_valid,
            tx_SS                  => tx_SS,
            MISO                   => MISO,
            tx_spi_valid           => tx_spi_valid,
            assembler_done_led     => assembler_done_led,
            vector_done_led        => vector_done_led,
            qte_start              => qte_start,
            qte_valid              => qte_valid,
            evo_complete           => evo_complete,
            psi_done_led           => psi_done_led,
            sclk_led               => sclk_led,
            psi_matrix_assemble_done => psi_matrix_assemble_done
        );

    -- Main stimulus process
    stim_proc : process

        -----------------------------------------------------------------------
        -- Send one 72-bit word to the matrix SPI receiver
        -----------------------------------------------------------------------
        procedure spi_send_matrix(data : std_logic_vector(NUM_BITS-1 downto 0)) is
        begin
            rx_matrix_SS <= '0';
            wait for SPI_SETUP;
            for i in NUM_BITS-1 downto 0 loop
                rx_matrix_MOSI <= data(i);
                wait for SPI_SETUP;
                SCLK <= '1';
                wait for SPI_HALF;
                SCLK <= '0';
                wait for SPI_HALF;
            end loop;
            rx_matrix_MOSI <= '0';
            wait for SPI_SETUP;
            rx_matrix_SS <= '1';
            wait for SPI_HALF * 4;  -- inter-word gap
        end procedure;

        -----------------------------------------------------------------------
        -- Send one 72-bit word to the vector SPI receiver
        -----------------------------------------------------------------------
        procedure spi_send_vector(data : std_logic_vector(NUM_BITS-1 downto 0)) is
        begin
            rx_vector_SS <= '0';
            wait for SPI_SETUP;
            for i in NUM_BITS-1 downto 0 loop
                rx_vector_MOSI <= data(i);
                wait for SPI_SETUP;
                SCLK <= '1';
                wait for SPI_HALF;
                SCLK <= '0';
                wait for SPI_HALF;
            end loop;
            rx_vector_MOSI <= '0';
            wait for SPI_SETUP;
            rx_vector_SS <= '1';
            wait for SPI_HALF * 4;
        end procedure;

        -----------------------------------------------------------------------
        -- Clock out one 72-bit word from the TX SPI and capture MISO
        -- The transmitter needs NUM_BITS+1 rising edges: NUM_BITS for data,
        -- plus 1 extra to trigger the spi_valid/tx_done pulse.
        -----------------------------------------------------------------------
        procedure spi_read_word(variable result : out std_logic_vector(NUM_BITS-1 downto 0)) is
            variable captured : std_logic_vector(NUM_BITS-1 downto 0);
        begin
            tx_SS <= '0';
            wait for SPI_SETUP;
            for i in 0 to NUM_BITS loop
                SCLK <= '1';
                wait for SPI_HALF;
                if i < NUM_BITS then
                    captured(NUM_BITS-1-i) := MISO;
                end if;
                SCLK <= '0';
                wait for SPI_HALF;
            end loop;
            wait for SPI_SETUP;
            tx_SS <= '1';
            result := captured;
            wait for SPI_HALF * 4;
        end procedure;

        variable rx_word : std_logic_vector(NUM_BITS-1 downto 0);

        -- File output for results
        file     outfile : text;
        variable fstatus : file_open_status;
        variable ln      : line;
    begin
        -----------------------------------------------------------------------
        -- Phase 1: Reset
        -----------------------------------------------------------------------
        report "QPU TB: Resetting...";
        reset  <= '1';
        enable <= '0';
        SCLK   <= '0';
        wait for CLK_PERIOD * 10;
        reset <= '0';
        wait for CLK_PERIOD * 5;

        -----------------------------------------------------------------------
        -- Phase 2: Send Hamiltonian matrix (receive mode)
        -----------------------------------------------------------------------
        report "QPU TB: Entering receive mode, sending Hamiltonian...";
        enable <= '1';
        wait for CLK_PERIOD * 3;

        spi_send_matrix(H00);  -- H(0,0) = 0+0i
        spi_send_matrix(H01);  -- H(0,1) = 1+0i
        spi_send_matrix(H10);  -- H(1,0) = 1+0i
        spi_send_matrix(H11);  -- H(1,1) = 0+0i
        report "QPU TB: Matrix sent.";

        -----------------------------------------------------------------------
        -- Phase 3: Send initial state vector
        -----------------------------------------------------------------------
        report "QPU TB: Sending state vector...";
        spi_send_vector(PSI0); -- psi(0) = 1+0i
        spi_send_vector(PSI1); -- psi(1) = 0+0i
        report "QPU TB: Vector sent.";

        -----------------------------------------------------------------------
        -- Phase 4: Wait for quantum time evolution to complete
        -----------------------------------------------------------------------
        report "QPU TB: Waiting for evolution to complete...";
        wait until psi_matrix_assemble_done = '1' for 20 ms;

        if psi_matrix_assemble_done /= '1' then
            report "QPU TB: TIMEOUT waiting for psi_matrix_assemble_done!" severity failure;
        end if;
        report "QPU TB: Evolution complete!";
        wait for CLK_PERIOD * 5;

        -----------------------------------------------------------------------
        -- Phase 5: Read back results (transmit mode)
        -----------------------------------------------------------------------
        report "QPU TB: Entering transmit mode, reading results...";
        enable <= '0';
        wait for CLK_PERIOD * 5;

        -- 30 time steps * 2 vector elements = 60 words
        for w in 0 to 59 loop
            spi_read_word(rx_word);
            rx_results(w) <= rx_word;
        end loop;
        report "QPU TB: All 60 result words received.";

        -----------------------------------------------------------------------
        -- Phase 5b: Write results to file
        -----------------------------------------------------------------------
        file_open(fstatus, outfile, "qpu_results.txt", write_mode);
        assert fstatus = open_ok
            report "QPU TB: Could not open qpu_results.txt for writing!"
            severity failure;
        for w in 0 to 59 loop
            write(ln, slv_to_hexstr(rx_results(w)));
            writeline(outfile, ln);
        end loop;
        file_close(outfile);
        report "QPU TB: Results written to qpu_results.txt";

        -----------------------------------------------------------------------
        -- Phase 6: End simulation
        -----------------------------------------------------------------------
        report "QPU TB: Simulation complete.";
        sim_done <= true;
        wait;
    end process;

end architecture sim;
