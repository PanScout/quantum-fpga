library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_receive is
    generic (
        NUM_BITS : integer := 28  -- Number of bits to receive.
    );
    port (
        clk       : in  std_logic;  -- FPGA system clock.
        reset     : in  std_logic;  -- Synchronous reset (active high)
        enable    : in  std_logic;  -- When '0', device is disabled.
        SCLK      : in  std_logic;  -- External SPI clock signal (RAW input).
        SS        : in  std_logic;  -- Active low chip select (RAW input).
        MOSI      : in  std_logic;  -- External SPI data input (RAW input).
        NUM       : out std_logic_vector(NUM_BITS-1 downto 0); -- Final word output
        -- spi_valid is high WHEN state is VALID
        spi_valid : out std_logic
    );
end spi_receive;

architecture Behavioral of spi_receive is

    -- State machine definition
    type state_type is (IDLE, RECEIVING, VALID);
    signal state          : state_type := IDLE;

    -- Internal data register (accumulates bits MSB-first)
    signal num_reg        : std_logic_vector(NUM_BITS-1 downto 0) := (others => '0');
    -- Output data register (holds stable output value)
    signal num_output_reg : std_logic_vector(NUM_BITS-1 downto 0) := (others => '0');

    -- Counter to track number of bits received.
    signal bit_count      : integer range 0 to NUM_BITS := 0; -- Can reach NUM_BITS momentarily

    -- Input Synchronization Registers
    signal sclk_s1, sclk_s2 : std_logic := '0'; -- Synchronized SCLK stages
    signal ss_s1,   ss_s2   : std_logic := '0'; -- Synchronized SS stages (init high/idle)
    signal mosi_s1, mosi_s2 : std_logic := '0'; -- Synchronized MOSI stages

    -- Synchronized SCLK edge detection
    signal sclk_sync_d1   : std_logic := '0'; -- Previous cycle's synchronized SCLK

begin

    -- Synchronization Process
    sync_proc: process(clk, SCLK)
    begin
        if rising_edge(clk) then
            sclk_s1 <= SCLK; sclk_s2 <= sclk_s1;
            ss_s1   <= SS;   ss_s2   <= ss_s1;
            mosi_s1 <= MOSI; mosi_s2 <= mosi_s1;
        end if;
    end process sync_proc;

    -- Main SPI Logic Process
    spi_logic_proc: process(clk)
        -- Temporary variable to construct the final value before assigning to output register
        variable temp_num : std_logic_vector(NUM_BITS-1 downto 0);
    begin
        if rising_edge(clk) then
            -- Synchronous Reset
            if reset = '1' then
                state          <= IDLE;
                bit_count      <= 0;
                num_reg        <= (others => '0');
                num_output_reg <= (others => '0');
            -- Disabled or Chip Select Inactive (Go to IDLE)
            elsif (enable = '0' or ss_s2 = '1') then
                 -- If SS goes high, reset the process regardless of current state
                state          <= IDLE;
                bit_count      <= 0;
                num_reg        <= (others => '0');
                -- Decide if NUM should reset when SS goes high, or hold last value. Resetting here.
                num_output_reg <= (others => '0');
            -- Enabled and Chip Selected - Normal Operation
            else
                -- Store previous synchronized SCLK for edge detection
                sclk_sync_d1 <= sclk_s2;
                -- Output register holds its value unless explicitly updated
                -- num_output_reg <= num_output_reg; -- (Implicit)

                -- Detect rising edge of synchronized SCLK (Samples data - assumes CPOL=0, CPHA=0 or CPOL=1, CPHA=1)
                if ((sclk_s2 = '1') and (sclk_sync_d1 = '0')) then
                    case state is
                        when IDLE =>
                            -- SS is low (checked by outer condition), SCLK rising: Start transfer
                            -- Capture first bit (MSB)
                            num_reg <= (others => '0'); -- Clear internal register
                            num_reg(NUM_BITS-1) <= mosi_s2;
                            bit_count <= 1; -- We have received 1 bit
                            state     <= RECEIVING;

                        when RECEIVING =>
                             -- SS is low, SCLK rising: Capture next bit
                             -- Place bit at index (NUM_BITS - 1 - current_bit_count)
                             -- Example: NUM_BITS=8. bit_count=1 -> index 6. bit_count=7 -> index 0.
                            if (NUM_BITS - 1 - bit_count) >= 0 then -- Check index valid
                                num_reg(NUM_BITS - 1 - bit_count) <= mosi_s2;
                            end if;

                            if bit_count = NUM_BITS - 1 then
                                -- This SCLK edge just clocked in the LAST bit (LSB) at index 0
                                -- Prepare the final value for the output register
                                temp_num := num_reg;        -- Get bits already placed (MSB down to index 1)
                                temp_num(0) := mosi_s2;     -- Add the final LSB just received

                                -- Update state and the stable output register
                                state          <= VALID;
                                num_output_reg <= temp_num; -- *** Update NUM output ***
                                bit_count      <= 0;       -- Reset bit count for next potential transfer
                            else
                                -- Not the last bit yet
                                bit_count <= bit_count + 1;
                                state     <= RECEIVING; -- Stay in RECEIVING state
                            end if;

                        when VALID =>
                             -- Currently in VALID state (spi_valid output is high).
                             -- A full word was received on the *previous* clock edge.
                             -- Output register holds the complete word.
                             -- If SS is still low on this new SCLK edge: start a new transfer immediately.
                             -- Capture first bit (MSB) of the new word.
                             num_reg <= (others => '0');
                             num_reg(NUM_BITS-1) <= mosi_s2;
                             bit_count <= 1;
                             state     <= RECEIVING; -- Exit VALID state, start receiving next word

                    end case; -- state
                -- No SCLK edge detected this clock cycle
                else
                     -- If we were in VALID state, and SS is still low, but there's no SCLK edge,
                     -- just stay VALID. Transition out happens only on SCLK edge (above) or SS going high (outer condition).
                     null;
                end if; -- End rising edge SCLK detection
            end if; -- End reset/enable/SS condition
        end if; -- End rising_edge(clk)
    end process spi_logic_proc;

    -- Drive outputs continuously
    NUM <= num_output_reg;
    -- spi_valid is high ('1') if and only if the state machine is in the VALID state.
    spi_valid <= '1' when state = VALID else '0';

end Behavioral;
