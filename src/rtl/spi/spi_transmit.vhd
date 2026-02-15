library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_transmit is
    generic (
        NUM_BITS : integer := 72 -- Number of bits to transmit.
    );
    port (
        clk       : in  std_logic;  -- FPGA system clock.
        enable    : in  std_logic;  -- When '0', device is disabled.
        data_in   : in  std_logic_vector(NUM_BITS - 1 downto 0); -- Data word to be transmitted.
        SCLK_in   : in  std_logic;  -- External SPI clock signal (RAW input).
        SS_in     : in  std_logic;  -- Active low chip select (RAW input).
        MISO      : out std_logic;  -- Output line to send data to the master.
        spi_valid : out std_logic -- Asserted when a full word is transmitted (optional use).
    );
end spi_transmit;

architecture Behavioral of spi_transmit is

    -- Input Synchronization Registers
    signal sclk_s1, sclk_s2 : std_logic := '0';
    signal ss_s1, ss_s2     : std_logic := '1'; -- Default SS to idle (high)

    -- Synchronized Signals
    signal SCLK : std_logic;
    signal SS   : std_logic;

    -- State machine
    type state_type is (IDLE, TRANSMITTING); -- Simplified state
    signal state     : state_type := IDLE;

    -- Pattern removed, using data_in port instead
    -- constant PATTERN : std_logic_vector(NUM_BITS-1 downto 0) := "111100001111000011110000111100001111000011110000111100001111000011110000";

    -- Counter tracks how many bits have been sent. Reset state sends bit MSB.
    -- Counts from 0 (ready to send MSB) up to NUM_BITS (finished sending LSB).
    signal bit_counter : integer range 0 to NUM_BITS := 0;

    -- Internal signals
    signal miso_reg   : std_logic := '0';
    signal valid_reg  : std_logic := '0'; -- Will pulse for one clk cycle

    -- Edge detection for synchronized SCLK
    signal sclk_last  : std_logic := '0';
    signal sclk_rising_edge : boolean;

begin

    -- Input Synchronization
    process(clk)
    begin
        if rising_edge(clk) then
            sclk_s1 <= SCLK_in;
            sclk_s2 <= sclk_s1;
            ss_s1   <= SS_in;
            ss_s2   <= ss_s1;
        end if;
    end process;
    SCLK <= sclk_s2; -- Use synchronized SCLK
    SS   <= ss_s2;   -- Use synchronized SS

    -- Main SPI Logic
    process(clk)
    begin
        if rising_edge(clk) then
            -- Default assignments
            valid_reg <= '0'; -- Default valid low, pulse high when done
            sclk_rising_edge <= (SCLK = '1' and sclk_last = '0'); -- Detect edge on synchronized SCLK

            -- Reset condition
            if (enable = '0' or SS = '1') then -- Reset if disabled OR slave deselected
                state       <= IDLE;
                bit_counter <= 0;
                miso_reg    <= '0'; -- Or 'Z' if tristate needed
                valid_reg   <= '0';
            else
                -- Active state machine (SS='0' and enable='1')
                -- Logic reacts to the SCLK edge detected *in the previous cycle*
                if sclk_rising_edge then
                    case state is
                        when IDLE =>
                            -- First rising edge detected while selected
                            -- Output MSB (index NUM_BITS-1) from the input data
                            miso_reg    <= data_in(NUM_BITS - 1);
                            bit_counter <= 1;                    -- Prepare for the next bit index
                            state       <= TRANSMITTING;
                            valid_reg   <= '0';

                        when TRANSMITTING =>
                            if bit_counter < NUM_BITS then
                                -- Subsequent rising edge detected
                                -- Output the bit corresponding to the current bit_counter
                                -- data_in is indexed MSB first (NUM_BITS-1 down to 0)
                                -- Counter goes 1, 2, ..., NUM_BITS-1
                                -- So we need data_in(NUM_BITS - 1 - bit_counter)
                                miso_reg    <= data_in(NUM_BITS - 1 - bit_counter); -- Output current bit
                                bit_counter <= bit_counter + 1;                  -- Increment for next edge
                                state       <= TRANSMITTING;
                                valid_reg   <= '0';
                            else
                                -- Rising edge #NUM_BITS detected (after sending NUM_BITS-1 on previous edge)
                                -- This edge doesn't correspond to a data bit in this MSB-first scheme.
                                -- The last bit (LSB, index 0) was put on MISO just before this edge.
                                miso_reg    <= '0'; -- Go low (or 'Z') after last bit transmission completed
                                bit_counter <= 0;   -- Reset for potential next transfer
                                state       <= IDLE; -- Go back to idle, ready for next sequence
                                valid_reg   <= '1'; -- Pulse valid for one FPGA clock cycle
                            end if;
                    end case;
                end if; -- end SCLK edge detection
            end if; -- end enable/SS check

            sclk_last <= SCLK; -- Update SCLK history for next cycle's edge detection
        end if; -- end rising_edge(clk)
    end process;

    -- Drive outputs
	 MISO <= miso_reg;
    spi_valid <= valid_reg;

end Behavioral;