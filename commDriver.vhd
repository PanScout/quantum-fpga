library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
  Port (
    clk      : in  STD_LOGIC;   -- FPGA system clock (100 MHz)
    reset    : in  STD_LOGIC;    -- Global reset
    -- FPGA-to-Pi Pins
    tx_data  : out STD_LOGIC_VECTOR(31 downto 0);
    tx_valid : out STD_LOGIC;
    pi_ack   : in  STD_LOGIC;
    tx_clk   : out STD_LOGIC;    -- Generated clock for synchronization
    -- Pi-to-FPGA Pins
    pi_data  : in  STD_LOGIC_VECTOR(31 downto 0);
    pi_valid : in  STD_LOGIC;
    rx_ack   : out STD_LOGIC
  );
end top;

architecture Behavioral of top is
  signal clk_10mhz : STD_LOGIC;
begin
  -- Clock generator for synchronization
  clk_gen_inst : entity work.clk_gen
    port map (
      clk_in  => clk,
      clk_out => clk_10mhz
    );

  -- Transmitter module
  tx_inst : entity work.parallel_tx
    port map (
      clk      => clk,
      reset    => reset,
      data_in  => x"12345678",  -- Replace with actual data source
      start    => '1',           -- Trigger continuously (customize as needed)
      tx_data  => tx_data,
      tx_valid => tx_valid,
      pi_ack   => pi_ack
    );

  -- Receiver module
  rx_inst : entity work.parallel_rx
    port map (
      clk      => clk,
      reset    => reset,
      pi_data  => pi_data,
      pi_valid => pi_valid,
      rx_ack   => rx_ack,
      data_out => open           -- Connect to internal logic
    );

  -- Output generated clock to Pi
  tx_clk <= clk_10mhz;
end Behavioral;
