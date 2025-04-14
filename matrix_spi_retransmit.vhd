library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Make sure these packages are available and define everything needed!
use work.fixed_pkg.ALL;
use work.qTypes.ALL; -- Needs dimension, fixed64, cfixed64, cmatrix

--=============================================================================
-- Entity: matrix_spi_retransmit -- <<< Name remains as requested
-- Description: Receives matrix when enable='1', transmits matrix when enable='0'.
--              Controlled by external master and top-level enable toggle.
--=============================================================================
entity matrix_spi_retransmit is
    port (
        -- System Clock. Still need this!
        clk     : in  std_logic;

        -- Control Signals
        reset   : in  std_logic;     -- Active High Reset. OVERRIDES enable.
        enable  : in  std_logic;     -- Active High = RECEIVE mode, Active Low = TRANSMIT mode (when not reset)

        -- External SPI Master Interface (YOUR signals!)
        SCLK    : in  std_logic;     -- SPI Clock from Master.
        SS      : in  std_logic;     -- SPI Slave Select from Master (Active LOW!).
        MOSI    : in  std_logic;     -- Data FROM Master.
        MISO    : out std_logic      -- Data TO Master.
    );
end entity matrix_spi_retransmit;

--=============================================================================
-- Architecture: retransmit_flow_toggled_enable
-- Description: Connects spi_receive -> assemble_matrix -> disassemble_matrix -> spi_transmit.
--              Uses top 'enable' to switch between receive and transmit modes.
--              Additionally, it captures the bits transmitted on MISO and appends
--              them into a long std_logic_vector (miso_log) for later inspection.
--              For every transmitted word, the first rising edge of SCLK is ignored,
--              and sampling starts on the second edge.
--=============================================================================
architecture retransmit_flow_toggled_enable of matrix_spi_retransmit is

    -- Constant for total number of bits transmitted (4 words * 72 bits each)
    constant TOTAL_TX_BITS : integer := 288;

    -- Constant for data word width (e.g., 2 * fixed64'length, which is 72 bits here)
    constant DATA_WIDTH : integer := 2 * fixed64'length;

    -- Internal Signals: Wires connecting the blocks.
    signal rx_data          : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal rx_valid         : std_logic;
    signal assembled_matrix : cmatrix;
    signal asm_done         : std_logic;
    signal asm_done_d1      : std_logic := '0';
    signal disasm_start     : std_logic;
    signal disasm_data      : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal disasm_valid     : std_logic;
    signal disasm_done      : std_logic;
    signal spi_tx_done_pulse: std_logic;

    -- Enable Signals based on top-level 'enable' and 'reset'
    signal receive_mode_enable  : std_logic; -- Active when enable = '1' and reset = '0'
    signal transmit_mode_enable : std_logic; -- Active when enable = '0' and reset = '0'

    -- Internal signal for driving and capturing MISO.
    signal miso_int : std_logic := '0';

    -- Signals for capturing transmitted MISO bits.
    -- miso_log stores all transmitted bits; log_ptr is the pointer index.
    signal miso_log : std_logic_vector(0 to TOTAL_TX_BITS - 1) := (others => '0');
    signal log_ptr  : integer range 0 to TOTAL_TX_BITS := 0;

    -- Helper signals for edge detection.
    signal sclk_prev : std_logic := '0';
    -- Flag to ignore the first rising edge for the current transmitted word.
    signal ignore_first_edge : std_logic := '1';

begin

    -- Drive the output port MISO with the internal signal miso_int.
    MISO <= miso_int;

    -- Derive mode enables.
    receive_mode_enable  <= enable and (not reset);
    transmit_mode_enable <= (not enable) and (not reset);

    ----------------------------------------------------------------------------
    -- Block 1: SPI Receiver (Active in RECEIVE mode)
    ----------------------------------------------------------------------------
    spi_receive_inst : entity work.spi_receive
        generic map (
            NUM_BITS => DATA_WIDTH
        )
        port map (
            clk       => clk,
            reset     => reset,
            enable    => receive_mode_enable,
            SCLK      => SCLK,
            SS        => SS,
            MOSI      => MOSI,
            NUM       => rx_data,
            spi_valid => rx_valid
        );

    ----------------------------------------------------------------------------
    -- Block 2: Matrix Assembler
    ----------------------------------------------------------------------------
    assemble_matrix_inst : entity work.assemble_matrix
        port map (
            clk        => clk,
            reset      => reset,
            data_in    => rx_data,
            valid_in   => rx_valid,
            matrix_out => assembled_matrix,
            done_out   => asm_done
        );

    ----------------------------------------------------------------------------
    -- Trigger Logic for Disassembly: Latch asm_done
    ----------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                asm_done_d1 <= '0';
            else
                asm_done_d1 <= asm_done;
            end if;
        end if;
    end process;
    disasm_start <= '1' when (asm_done = '1' and asm_done_d1 = '0') else '0';

    ----------------------------------------------------------------------------
    -- Block 3: Matrix Disassembler
    ----------------------------------------------------------------------------
    disassemble_matrix_inst : entity work.disassemble_matrix
        port map (
            clk              => clk,
            reset            => reset,
            start            => disasm_start,
            matrix_in        => assembled_matrix,
            tx_done_pulse_in => spi_tx_done_pulse,
            data_out         => disasm_data,
            valid_out        => disasm_valid,
            done_out         => disasm_done
        );

    ----------------------------------------------------------------------------
    -- Block 4: SPI Transmitter (Active in TRANSMIT mode)
    ----------------------------------------------------------------------------
    spi_transmit_inst : entity work.spi_transmit
        generic map (
            NUM_BITS => DATA_WIDTH
        )
        port map (
            clk       => clk,
            enable    => transmit_mode_enable,
            data_in   => disasm_data,
            SCLK_in   => SCLK,
            SS_in     => SS,
            MISO      => miso_int,
            spi_valid => spi_tx_done_pulse
        );

    ----------------------------------------------------------------------------
    -- Process: Capture MISO Output into miso_log (Sampling from 2nd rising edge
    -- for each transmitted word)
    --
    -- This process uses spi_tx_done_pulse as an indication that a word has completed.
    -- Whenever a new word is about to be transmitted (SS is low and transmit_mode_enable is '1'),
    -- we reset ignore_first_edge. Then, on the next rising edge of SCLK the first edge is ignored,
    -- and subsequent rising edges are captured until the word completes.
    ----------------------------------------------------------------------------
    miso_capture : process(clk)
    begin
        if rising_edge(clk) then
            -- Update previous SCLK for edge detection.
            sclk_prev <= SCLK;
            
            -- If not in transmit mode or SS is inactive, reset the ignore flag.
            if transmit_mode_enable /= '1' or SS /= '0' then
                ignore_first_edge <= '1';
            else
                -- If a word has completed, as indicated by spi_tx_done_pulse, prepare for a new word.
                if spi_tx_done_pulse = '1' then
                    ignore_first_edge <= '1';
                end if;

                -- Check for a rising edge on SCLK.
                if (sclk_prev = '0' and SCLK = '1') then
                    if ignore_first_edge = '1' then
                        -- Ignore this rising edge (the first of the transmission).
                        ignore_first_edge <= '0';
                    else
                        -- Capture the bit on this rising edge.
                        if log_ptr < TOTAL_TX_BITS then
                            miso_log(log_ptr) <= miso_int;
                            log_ptr <= log_ptr + 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process miso_capture;

end architecture retransmit_flow_toggled_enable;
