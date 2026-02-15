library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Importing fixed point and custom quantum types
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity assemble_psi_matrix is
    port (
         clk           : in  std_logic;
         reset         : in  std_logic;     -- Active high synchronous reset
         vector_in     : in  cvector;       -- Input: one entire column (cvector)
         valid_in      : in  std_logic;     -- Indicates vector_in is valid
         psi_matrix_out: out psi_matrix;    -- Output: assembled psi_matrix (30 columns)
         done_out      : out std_logic      -- High when psi matrix is fully assembled
    );
end entity assemble_psi_matrix;

architecture rtl of assemble_psi_matrix is

    -- State machine definition
    type state_t is (IDLE, RECEIVING, DONE);
    signal current_state, next_state : state_t;

    -- Constants for zero initialization (0.0 + j0.0)
    constant ZERO_fixed64  : fixed64 := to_sfixed(0.0, fixed64'high, fixed64'low);
    constant ZERO_cfixed64 : cfixed64 := (re => ZERO_fixed64, im => ZERO_fixed64);

    -- Internal storage for the psi matrix being assembled (30 columns)
    signal internal_psi : psi_matrix := (others => (others => ZERO_cfixed64));

    -- Column counter for indexing into the psi matrix
    constant NUM_COLUMNS : integer := 30;
    signal col_index_cnt : natural range 0 to NUM_COLUMNS - 1 := 0;

    -- Signals for valid_in edge detection
    signal valid_in_d1          : std_logic := '0';
    signal valid_in_rising_edge : std_logic;
    
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
    -- Process to Register valid_in for Edge Detection
    ------------------------------------------------------------------------------
    process(clk)
    begin
         if rising_edge(clk) then
              if reset = '1' then
                   valid_in_d1 <= '0';
              else
                   valid_in_d1 <= valid_in;
              end if;
         end if;
    end process;
    
    -- Generate a pulse on the rising edge of valid_in
    valid_in_rising_edge <= '1' when (valid_in = '1' and valid_in_d1 = '0') else '0';
    
    ------------------------------------------------------------------------------
    -- Synchronous Process: Capture Input cvectors into the psi matrix
    ------------------------------------------------------------------------------
    process(clk)
    begin
         if rising_edge(clk) then
              if reset = '1' then
                   col_index_cnt <= 0;
                   internal_psi <= (others => (others => ZERO_cfixed64));
              else
                   -- Capture the column (cvector) only when not in DONE state
                   if (current_state /= DONE) and (valid_in_rising_edge = '1') then
                        -- Store the incoming cvector into the current column
                        internal_psi(col_index_cnt) <= vector_in;
                        
                        -- Update column counter if this is not the last column
                        if col_index_cnt < NUM_COLUMNS - 1 then
                             col_index_cnt <= col_index_cnt + 1;
                        end if;
                   end if;
              end if;
         end if;
    end process;
    
    ------------------------------------------------------------------------------
    -- Combinatorial Process: Next-State and Output Logic
    ------------------------------------------------------------------------------
    process(current_state, valid_in_rising_edge, col_index_cnt, internal_psi)
    begin
         -- Default assignments
         next_state   <= current_state;
         done_out     <= '0';
         psi_matrix_out <= internal_psi;  -- Output reflects the internal psi matrix
         
         case current_state is
              when IDLE =>
                   -- On first valid input capture, move to RECEIVING state
                   if valid_in_rising_edge = '1' then
                        next_state <= RECEIVING;
                   else
                        next_state <= IDLE;
                   end if;
              
              when RECEIVING =>
                   -- When a valid column is captured, check for completion:
                   if valid_in_rising_edge = '1' then
                        -- If the current column index is at the last column, move to DONE
                        if col_index_cnt = NUM_COLUMNS - 1 then
                             next_state <= DONE;
                        else
                             next_state <= RECEIVING;
                        end if;
                   else
                        next_state <= RECEIVING;
                   end if;
              
              when DONE =>
                   -- Latch in DONE state and assert done_out
                   done_out <= '1';
                   next_state <= DONE;
              
              when others =>
                   next_state <= IDLE;
         end case;
    end process;

end architecture rtl;
