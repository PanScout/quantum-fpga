	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;
	-- Assuming 'dimension', 'fixed64', 'cfixed64', 'cmatrix' are defined here
	use work.fixed_pkg.ALL;
	use work.qTypes.ALL;

	entity assemble_matrix is
		 port (
			  -- Clock and Reset
			  clk      : in  std_logic;
			  reset    : in  std_logic;  -- Active high synchronous reset

			  -- Input Data Interface
			  data_in  : in  std_logic_vector( (2 * fixed64'length) - 1 downto 0); -- e.g., 72 bits: [RE(35 downto 0) | IM(35 downto 0)]
			  valid_in : in  std_logic;  -- Indicates data_in is valid

			  -- Output Data Interface
			  matrix_out : out cmatrix;      -- Assembled matrix
			  done_out   : out std_logic     -- High when matrix is assembled (latched until reset)
		 );
	end entity assemble_matrix;

	architecture rtl of assemble_matrix is

		 -- State machine definition
		 type state_t is (IDLE, RECEIVING, DONE);
		 signal current_state, next_state : state_t;

		 -- Constant for complex zero value (0.0 + j0.0)
		 constant ZERO_fixed64  : fixed64 := to_sfixed(0.0, fixed64'high, fixed64'low);
		 constant ZERO_cfixed64 : cfixed64 := (re => ZERO_fixed64, im => ZERO_fixed64);

		 -- Internal storage for the matrix being assembled, with default initialization to zero.
		 signal internal_matrix : cmatrix := (others => (others => ZERO_cfixed64));

		 -- Counters for matrix indices
		 signal row_index_cnt : natural range 0 to dimension - 1; -- Range exactly matches index
		 signal col_index_cnt : natural range 0 to dimension - 1; -- Range exactly matches index

		 -- Constants for data slicing
		 constant F_LEN       : integer := fixed64'length; -- e.g., 36
		 constant RE_HIGH     : integer := (2*F_LEN) - 1;  -- e.g., 71
		 constant RE_LOW      : integer := F_LEN;         -- e.g., 36
		 constant IM_HIGH     : integer := F_LEN - 1;     -- e.g., 35
		 constant IM_LOW      : integer := 0;             -- e.g., 0

		 -- Signals for valid_in edge detection
		 signal valid_in_d1          : std_logic := '0'; -- Previous cycle's valid_in
		 signal valid_in_rising_edge : std_logic;      -- High for one cycle on valid_in 0->1

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

		 -- Process to register valid_in for edge detection
		 process(clk)
		 begin
			  if rising_edge(clk) then
					if reset = '1' then
						 valid_in_d1 <= '0';
					else
						 valid_in_d1 <= valid_in; -- Store current valid_in for next cycle
					end if;
			  end if;
		 end process;

		 -- Combinatorial logic for edge detection
		 valid_in_rising_edge <= '1' when (valid_in = '1' and valid_in_d1 = '0') else '0';


		 -- Index Counters and Internal Matrix Register Process (Synchronous)
		 process(clk)
			  variable temp_cfixed64 : cfixed64;
			  variable temp_re_slv   : std_logic_vector(F_LEN - 1 downto 0);
			  variable temp_im_slv   : std_logic_vector(F_LEN - 1 downto 0);
		 begin
			  if rising_edge(clk) then
					if reset = '1' then
						 row_index_cnt <= 0;
						 col_index_cnt <= 0;
						 -- Reset the internal matrix to zero
						 internal_matrix <= (others => (others => ZERO_cfixed64));
					else
						 -- *** MODIFIED: Capture data whenever a rising edge is detected,
						 -- *** as long as the state machine is not already DONE.
						 -- *** This captures the first element during the IDLE -> RECEIVING transition.
						 -- if current_state = RECEIVING and valid_in_rising_edge = '1' then -- OLD condition
						 if current_state /= DONE and valid_in_rising_edge = '1' then  -- *** NEW Condition ***
							  -- Slice input data
							  temp_re_slv := data_in(RE_HIGH downto RE_LOW);
							  temp_im_slv := data_in(IM_HIGH downto IM_LOW);

							  -- Convert std_logic_vector slices to sfixed
							  -- Ensure the conversion uses the correct bounds from fixed64 type
							  temp_cfixed64.re := sfixed(temp_re_slv);
							  temp_cfixed64.im := sfixed(temp_im_slv);

							  -- Store the converted value in the internal matrix at the current indices
							  internal_matrix(row_index_cnt)(col_index_cnt) <= temp_cfixed64;

							  -- Update indices for the *next* element, *unless* we just wrote the last one
							  -- This check is important so indices don't increment after the last element is stored
							  if not (row_index_cnt = dimension - 1 and col_index_cnt = dimension - 1) then
									if col_index_cnt = dimension - 1 then -- End of a row
										 col_index_cnt <= 0;
										 row_index_cnt <= row_index_cnt + 1;
									else
										 -- Move to next column in the same row
										 col_index_cnt <= col_index_cnt + 1;
									end if;
							  end if;
						 end if; -- End of data capture logic based on valid_in_rising_edge
					end if; -- End of reset check
			  end if; -- End of rising_edge check
		 end process; -- End of synchronous process

		 -- Next State Logic and Output Logic Process (Combinatorial)
		 -- Sensitivity list includes edge signal for correct transitions
		 process(current_state, valid_in_rising_edge, row_index_cnt, col_index_cnt, internal_matrix)
		 begin
			  -- Default assignments
			  next_state  <= current_state;
			  done_out    <= '0'; -- Default done to low
			  matrix_out  <= internal_matrix; -- Output continuously reflects internal state

			  case current_state is
					when IDLE =>
						 -- If a rising edge is detected, start receiving (or go straight to DONE if 1x1)
						 if valid_in_rising_edge = '1' then
								if dimension = 0 then -- Handle 0-dim case gracefully if needed
									 next_state <= IDLE; -- Or perhaps DONE? Depends on requirement.
								elsif dimension = 1 then -- Special case: matrix is 1x1
									 -- The first valid data completes the 1x1 matrix
									 next_state <= DONE;
								else
									 -- Start receiving subsequent elements
									 next_state <= RECEIVING;
								end if;
						 else
							  -- Stay idle if no valid data starts the process
							  next_state <= IDLE;
						 end if;

					when RECEIVING =>
						 done_out <= '0'; -- Explicitly not done yet while receiving
						 -- Check if the element *just processed* (in the clocked process) was the last one.
						 -- This decision is based on the state *before* the clock edge.
						 if valid_in_rising_edge = '1' then
							  if (row_index_cnt = dimension - 1) and (col_index_cnt = dimension - 1) then
									-- The data captured on this rising edge was the last element.
									next_state <= DONE;
							  else
									-- More elements are expected. Stay in RECEIVING state.
									next_state <= RECEIVING;
							  end if;
						 else
							  -- If no new data arrived, just stay in RECEIVING, waiting.
							  next_state <= RECEIVING;
						 end if;

					when DONE =>
						 done_out <= '1';    -- Assembly finished, assert done
						 next_state <= DONE; -- Latch in DONE state until reset

					when others => -- Should not happen, but good practice
						 next_state <= IDLE;
			  end case;
		 end process; -- End of combinatorial process

	end architecture rtl;
