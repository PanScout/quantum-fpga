library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parallel_tx is
  Port (
    clk      : in  STD_LOGIC;         -- FPGA system clock
    reset    : in  STD_LOGIC;         -- Global reset
    data_in  : in  STD_LOGIC_VECTOR(31 downto 0);  -- Data to send
    start    : in  STD_LOGIC;         -- Trigger transmission
    tx_data  : out STD_LOGIC_VECTOR(31 downto 0);  -- Data bus to Pi
    tx_valid : out STD_LOGIC;         -- VALID signal
    pi_ack   : in  STD_LOGIC          -- ACK from Pi
  );
end parallel_tx;

architecture Behavioral of parallel_tx is
  type state_t is (IDLE, SEND, WAIT_ACK);
  signal state : state_t := IDLE;
begin
  process(clk, reset)
  begin
    if reset = '1' then
      state    <= IDLE;
      tx_valid <= '0';
      tx_data  <= (others => '0');
    elsif rising_edge(clk) then
      case state is
        when IDLE =>
          if start = '1' then
            tx_data  <= data_in;  -- Load data onto the bus
            tx_valid <= '1';      -- Assert VALID
            state    <= SEND;
          end if;

        when SEND =>
          if pi_ack = '1' then   -- Wait for Pi to acknowledge
            tx_valid <= '0';      -- Deassert VALID
            state    <= WAIT_ACK;
          end if;

        when WAIT_ACK =>
          if pi_ack = '0' then    -- Wait for Pi to deassert ACK
            state <= IDLE;
          end if;
      end case;
    end if;
  end process;
end Behavioral;
