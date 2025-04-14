library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity disassemble_psi_matrix is
    port (
         clk              : in  std_logic;
         reset            : in  std_logic;  -- Active high synchronous reset
         start            : in  std_logic;  -- Start the disassembly process

         psi_matrix_in    : in  psi_matrix; -- Input assembled psi_matrix (30 columns)

         -- Handshake Signal Input:
         tx_done_pulse_in : in  std_logic;   -- Pulse indicating SPI transmitter is ready for next word

         -- Output Data Interface:
         data_out         : out std_logic_vector((2 * fixed64'length) - 1 downto 0);
                                         -- 72 bits: [RE(..) | IM(..)]
         valid_out        : out std_logic;  -- High when data_out is valid
         done_out         : out std_logic   -- High when disassembly is complete and last word acknowledged
    );
end entity disassemble_psi_matrix;

architecture rtl of disassemble_psi_matrix is

    -- State machine definition:
    -- IDLE:         Waiting for start
    -- SENDING_WAIT: Output current word and wait for acknowledgement (tx_done_pulse_in)
    -- SENDING_ADVANCE: Acknowledge receipt and advance counters (i.e. move to the next element)
    -- DONE:         All elements sent and acknowledged
    type state_t is (IDLE, SENDING_WAIT, SENDING_ADVANCE, DONE);
    signal current_state, next_state : state_t := IDLE;

    -- Constant for fixed64 slicing length (e.g., 36 bits for fixed64)
    constant F_LEN : integer := fixed64'length;

    -- psi_matrix has 30 columns (each column is a cvector of length "dimension")
    constant NUM_COLUMNS : integer := 30;

    -- Two counters:
    -- col_index_cnt: which column (0 to NUM_COLUMNS-1)
    -- row_index_cnt: which element of the column (0 to dimension-1)
    signal col_index_cnt : natural range 0 to NUM_COLUMNS - 1 := 0;
    signal row_index_cnt : natural range 0 to dimension - 1 := 0;

    -- Signal to trigger the counters' advancement in the next clock cycle
    signal advance_counters : std_logic := '0';

begin

    ------------------------------------------------------------------------------
    -- State Register Process (Synchronous)
    ------------------------------------------------------------------------------
    process(clk)
    begin
         if rising_edge(clk) then
              if reset = '1' then
                   current_state <= IDLE;
              else
                   current_state <= next_state;
              end if;
         end if;
    end process;

    ------------------------------------------------------------------------------
    -- Counters Process (Synchronous)
    -- Iterates over each psi_matrix element (each element is a cfixed64 within a cvector).
    ------------------------------------------------------------------------------
    process(clk)
    begin
         if rising_edge(clk) then
              if reset = '1' then
                   col_index_cnt <= 0;
                   row_index_cnt <= 0;
              elsif advance_counters = '1' then
                   if row_index_cnt = dimension - 1 then
                        -- End of current column: reset row counter and advance column counter
                        row_index_cnt <= 0;
                        if col_index_cnt < NUM_COLUMNS - 1 then
                             col_index_cnt <= col_index_cnt + 1;
                        end if;
                   else
                        -- Advance within the current column
                        row_index_cnt <= row_index_cnt + 1;
                   end if;
              elsif next_state = IDLE and current_state /= IDLE then
                   -- Reset counters when returning to IDLE (if needed)
                   col_index_cnt <= 0;
                   row_index_cnt <= 0;
              end if;
         end if;
    end process;

    ------------------------------------------------------------------------------
    -- Next-State and Output Logic Process (Combinatorial)
    ------------------------------------------------------------------------------
    process(current_state, start, tx_done_pulse_in, col_index_cnt, row_index_cnt, psi_matrix_in)
        variable is_last_element : boolean;
    begin
         -- Default assignments
         next_state      <= current_state;
         valid_out       <= '0';
         done_out        <= '0';
         data_out        <= (others => '0');
         advance_counters <= '0';  -- Default: do not advance counters

         -- Determine if the current element is the last element in the psi_matrix
         is_last_element := (col_index_cnt = NUM_COLUMNS - 1) and (row_index_cnt = dimension - 1);

         case current_state is
              when IDLE =>
                   if start = '1' then
                        if NUM_COLUMNS > 0 then
                             next_state <= SENDING_WAIT;
                        else
                             next_state <= DONE;  -- In the unusual case of an empty psi_matrix
                        end if;
                   else
                        next_state <= IDLE;
                   end if;

              when SENDING_WAIT =>
                   -- Output the current psi_matrix element:
                   data_out <= to_slv(psi_matrix_in(col_index_cnt)(row_index_cnt).re) &
                               to_slv(psi_matrix_in(col_index_cnt)(row_index_cnt).im);
                   valid_out <= '1';
                   if tx_done_pulse_in = '1' then
                        next_state <= SENDING_ADVANCE;
                   else
                        next_state <= SENDING_WAIT;
                   end if;

              when SENDING_ADVANCE =>
                   -- Maintain outputs while advancing counters
                   data_out <= to_slv(psi_matrix_in(col_index_cnt)(row_index_cnt).re) &
                               to_slv(psi_matrix_in(col_index_cnt)(row_index_cnt).im);
                   valid_out <= '1';
                   advance_counters <= '1';  -- Trigger the counter update in the next clock edge
                   if is_last_element then
                        next_state <= DONE;
                   else
                        next_state <= SENDING_WAIT;
                   end if;

              when DONE =>
                   valid_out <= '0';
                   done_out  <= '1';
                   next_state <= DONE;

              when others =>
                   next_state <= IDLE;
         end case;
    end process;

end architecture rtl;
