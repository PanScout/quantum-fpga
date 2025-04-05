library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parallel_rx is
  Port (
    clk       : in  STD_LOGIC;
    reset     : in  STD_LOGIC;
    pi_data   : in  STD_LOGIC_VECTOR(31 downto 0);  -- Data bus from Pi
    pi_valid  : in  STD_LOGIC;                      -- VALID signal from Pi
    rx_ack    : out STD_LOGIC;                      -- ACK to Pi
    data_out  : out STD_LOGIC_VECTOR(31 downto 0)    -- Received data
  );
end parallel_rx;

architecture Behavioral of parallel_rx is
  type state_t is (IDLE, READ);
  signal state : state_t := IDLE;
begin
  process(clk, reset)
  begin
    if reset = '1' then
      state    <= IDLE;
      rx_ack   <= '0';
      data_out <= (others => '0');
    elsif rising_edge(clk) then
      case state is
        when IDLE =>
          if pi_valid = '1' then
            data_out <= pi_data;  -- Latch data
            rx_ack   <= '1';      -- Assert ACK
            state    <= READ;
          end if;

        when READ =>
          if pi_valid = '0' then  -- Wait for Pi to deassert VALID
            rx_ack <= '0';
            state  <= IDLE;
          end if;
      end case;
    end if;
  end process;
end Behavioral;
