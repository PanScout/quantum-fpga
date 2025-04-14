library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity disassemble_matrix is
    port (
        clk              : in  std_logic;
        reset            : in  std_logic;  -- Active high synchronous reset
        start            : in  std_logic;  -- Start the disassembly process

        matrix_in        : in  cmatrix;    -- Input assembled matrix

        -- Handshake Signal Input
        tx_done_pulse_in : in std_logic;   -- Pulse indicating SPI transmitter is ready for next word

        -- Output Data Interface
        data_out         : out std_logic_vector((2 * fixed64'length) - 1 downto 0);
                                            -- 72 bits: [RE(..)|IM(..)] -- Adjusted comment based on previous findings
        valid_out        : out std_logic;  -- High when data_out is valid AND module is ready to send
        done_out         : out std_logic   -- High when matrix disassembly is complete and last word acknowledged
    );
end entity disassemble_matrix;

architecture rtl of disassemble_matrix is

    -- State machine definition
    -- IDLE: Waiting for start
    -- SENDING_WAIT: Outputting current word, waiting for transmitter acknowledge (tx_done_pulse_in)
    -- SENDING_ADVANCE: Acknowledge received, prepare to advance counters on next clock edge
    -- DONE: All elements sent and acknowledged
    type state_t is (IDLE, SENDING_WAIT, SENDING_ADVANCE, DONE);
    signal current_state, next_state : state_t := IDLE;

    -- Constant for data slicing length (e.g., 36 bits for fixed64)
    constant F_LEN : integer := fixed64'length;

    -- Counters for matrix indices (assumes "dimension" is defined in qTypes)
    signal row_index_cnt : natural range 0 to dimension - 1 := 0;
    signal col_index_cnt : natural range 0 to dimension - 1 := 0;

    -- Internal signal to control counter updates
    signal advance_counters : std_logic := '0';

begin

    -- State Register Process (Synchronous)
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

    -- Index Counters Process (Synchronous)
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                row_index_cnt <= 0;
                col_index_cnt <= 0;
            elsif advance_counters = '1' then -- Only advance when triggered
                 -- Check if we were processing the last element (before advancing)
                if (row_index_cnt = dimension - 1) and (col_index_cnt = dimension - 1) then
                    -- Should not advance if already at the end, FSM handles this transition
                    -- Reset counters if needed, or hold. Let's reset for clarity if we exit SENDING state.
                     -- Handled by IDLE state entry / Reset more reliably. Keep state here.
                     null; -- No change needed here if FSM handles DONE transition correctly
                elsif col_index_cnt = dimension - 1 then
                    -- End of row: reset column counter and move to next row.
                    col_index_cnt <= 0;
                    row_index_cnt <= row_index_cnt + 1;
                else
                    -- Move to next column in the same row.
                    col_index_cnt <= col_index_cnt + 1;
                end if;
            elsif next_state = IDLE and current_state /= IDLE then -- Reset counters when returning to IDLE
                 row_index_cnt <= 0;
                 col_index_cnt <= 0;
            end if;
        end if;
    end process;

    -- Next State Logic and Output Conversion Process (Combinatorial)
    process(current_state, start, tx_done_pulse_in, row_index_cnt, col_index_cnt, matrix_in)
        variable is_last_element : boolean;
    begin
        -- Default assignments
        next_state      <= current_state;
        valid_out       <= '0';



        done_out        <= '0';
        data_out        <= (others => '0');
        advance_counters <= '0'; -- Default: do not advance counters

        -- Determine if the current indices point to the last element
        is_last_element := (row_index_cnt = dimension - 1) and (col_index_cnt = dimension - 1);

        case current_state is
            when IDLE =>
                valid_out <= '0';
                done_out  <= '0';
                if start = '1' then
                    if dimension > 0 then -- Don't start if matrix is empty
                       next_state <= SENDING_WAIT;
                    else
                       next_state <= DONE; -- Empty matrix is instantly done? Or stay IDLE? Let's go DONE.
                    end if;
                else
                    next_state <= IDLE;
                end if;

            when SENDING_WAIT =>
                -- Output the current matrix element
                data_out  <= to_slv(matrix_in(row_index_cnt)(col_index_cnt).re) &
                             to_slv(matrix_in(row_index_cnt)(col_index_cnt).im);
                valid_out <= '1'; -- Data is valid, waiting for TX ready
                done_out  <= '0';

                -- Wait for the transmitter to signal it's done with this word
                if tx_done_pulse_in = '1' then
                    next_state <= SENDING_ADVANCE; -- Go to intermediate state to trigger counter advance
                else
                    next_state <= SENDING_WAIT; -- Stay here, keep outputting same data
                end if;

             when SENDING_ADVANCE =>
                 -- This state is primarily to signal the counter process.
                 -- We were in SENDING_WAIT, tx_done_pulse_in arrived.
                 -- Keep outputs same as SENDING_WAIT for this one cycle.
                 data_out  <= to_slv(matrix_in(row_index_cnt)(col_index_cnt).re) &
                              to_slv(matrix_in(row_index_cnt)(col_index_cnt).im);
                 valid_out <= '1'; -- Still valid as we transition
                 done_out  <= '0';
                 advance_counters <= '1'; -- Trigger counter update on next clock edge

                 -- Decide where to go next based on whether the *acknowledged* element was the last one
                 if is_last_element then
                     next_state <= DONE;
                 else
                     next_state <= SENDING_WAIT; -- Go back to wait for next acknowledgement
                 end if;

            when DONE =>
                valid_out <= '0';
                done_out  <= '1'; -- Signal completion
                -- Stay in DONE until reset or top-level FSM deasserts start (which causes reset via top FSM)
                next_state <= DONE;
                 -- Optional: Reset counters immediately on entering DONE?
                 -- Counter reset is handled by reset signal or transition back to IDLE

            when others =>
                next_state <= IDLE;
        end case;

        -- Ensure start = '0' forces back to IDLE unless already DONE
        -- Let top-level handle reset via enable/reset. Start only initiates.
        -- if start = '0' and current_state /= DONE then
        --    next_state <= IDLE;
        -- end if;

    end process;

end architecture rtl;