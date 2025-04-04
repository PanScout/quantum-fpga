library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_receiver is
    generic (
        NUM_BITS : integer := 72  -- Number of bits to receive.
    );
    port (
        clk       : in  std_logic;  -- FPGA system clock.
        enable    : in  std_logic;  -- When '0', device is disabled.
        SCLK      : in  std_logic;  -- External SPI clock signal (RAW input).
        SS        : in  std_logic;  -- Active low chip select (RAW input).
        MOSI      : in  std_logic;  -- External SPI data input (RAW input).
        NUM       : out std_logic_vector(NUM_BITS-1 downto 0);
        spi_valid : out std_logic  -- Asserted for one clk cycle when a full word is received.
    );
end spi_receiver;

architecture Behavioral of spi_receiver is

    -- State machine definition
    type state_type is (IDLE, RECEIVING, VALID);
    signal state     : state_type := IDLE;

    -- Data register
    signal num_reg   : std_logic_vector(NUM_BITS-1 downto 0) := (others => '0');
    -- Valid signal register (internal)
    signal valid_reg : std_logic := '0';

    -- Counter to track number of bits received.
    signal bit_count : integer range 0 to NUM_BITS := 0;

    -- Input Synchronization Registers
    signal sclk_s1, sclk_s2 : std_logic := '0'; -- Synchronized SCLK stages
    signal ss_s1,   ss_s2   : std_logic := '1'; -- Synchronized SS stages (init high/idle)
    signal mosi_s1, mosi_s2 : std_logic := '0'; -- Synchronized MOSI stages

    -- Synchronized SCLK edge detection
    signal sclk_sync_d1 : std_logic := '0'; -- Previous cycle's synchronized SCLK

begin

    -- Synchronization Process: Capture raw inputs into first stage FF, then into second stage FF
    sync_proc: process(clk)
    begin
        if rising_edge(clk) then
            -- Synchronize SCLK
            sclk_s1 <= SCLK;
            sclk_s2 <= sclk_s1;

            -- Synchronize SS
            ss_s1   <= SS;
            ss_s2   <= ss_s1;

            -- Synchronize MOSI
            mosi_s1 <= MOSI;
            mosi_s2 <= mosi_s1;
        end if;
    end process sync_proc;


    -- Main SPI Logic Process: Operates on synchronized signals
    spi_logic_proc: process(clk)
    begin
        if rising_edge(clk) then
            -- Store previous synchronized SCLK value for edge detection
            sclk_sync_d1 <= sclk_s2;

            -- Default Assignments (executed every clock cycle)
            valid_reg <= '0'; -- Default valid to low, ensures it's a pulse

            -- Reset Condition Check (using synchronized SS)
            if (enable = '0' or ss_s2 = '1') then
                state     <= IDLE;
                bit_count <= 0;
                num_reg   <= (others => '0');
                valid_reg <= '0'; -- Ensure valid is low on reset
            else
                -- Active State Machine Logic (enable='1' and synchronized SS='0')

                -- Detect rising edge of SYNCHRONIZED SCLK
                if (sclk_s2 = '1' and sclk_sync_d1 = '0') then
                    case state is
                        when IDLE =>
                             -- Start reception on the first SCLK edge when selected
                            if ss_s2 = '0' then -- Double check SS (already checked above, but good practice)
                                -- Capture first bit (MSB) using synchronized MOSI
                                num_reg(NUM_BITS-1) <= mosi_s2;
                                bit_count <= 1;
                                state     <= RECEIVING;
                                -- valid_reg remains '0' (set by default above)
                            end if;

                        when RECEIVING =>
                            -- Continue reception on subsequent SCLK edges
                            if ss_s2 = '0' then
                                -- Capture next bit using synchronized MOSI
                                -- Note: Indexing needs care. If bit_count is 1, we just captured bit NUM_BITS-1.
                                -- We now need to capture bit NUM_BITS-2. The index is NUM_BITS-1-bit_count.
                                num_reg(NUM_BITS - 1 - bit_count) <= mosi_s2;

                                if bit_count = NUM_BITS - 1 then
                                    -- This was the last bit (bit 0)
                                    state     <= VALID;
                                    valid_reg <= '1'; -- Assert valid for ONE clock cycle
                                    -- bit_count will reset on next SCLK edge or SS change
                                else
                                    bit_count <= bit_count + 1;
                                    -- state remains RECEIVING
                                    -- valid_reg remains '0'
                                end if;
                            else
                                -- Should not happen if outer check works, but handle SS going high mid-transfer
                                state     <= IDLE;
                                bit_count <= 0;
                                num_reg   <= (others => '0');
                                -- valid_reg remains '0'
                            end if;

                        when VALID =>
                            -- State after the last bit was received.
                            -- valid_reg was high for the previous cycle, now it's low again (default).
                            -- If still selected and another SCLK edge comes, start new reception.
                            if ss_s2 = '0' then
                                -- Begin new reception by capturing new bit into MSB.
                                num_reg(NUM_BITS-1) <= mosi_s2;
                                bit_count <= 1;
                                state     <= RECEIVING;
                            else
                                -- Deselected after VALID state
                                state     <= IDLE;
                                bit_count <= 0;
                                num_reg   <= (others => '0');
                            end if;
                            -- valid_reg remains '0'
                    end case;
                -- else -- No rising edge detected on sclk_s2 this clock cycle
                    -- If needed, logic could be added here to handle state changes
                    -- based only on SS (e.g., if SS goes high between SCLK edges)
                    -- but the main reset condition handles SS going high already.
                end if; -- End SCLK edge detection check
            end if; -- End enable/SS check
        end if; -- End rising_edge(clk)
    end process spi_logic_proc;

    -- Drive outputs continuously from internal registers
    NUM       <= num_reg;
    spi_valid <= valid_reg;

end Behavioral;