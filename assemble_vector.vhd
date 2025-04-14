library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity assemble_vector is
    port (
        -- Clock and Reset
        clk       : in  std_logic;
        reset     : in  std_logic;  -- Active high synchronous reset

        -- Input Data Interface
        data_in   : in  std_logic_vector((2 * fixed64'length) - 1 downto 0);  -- 72 bits: [RE(35 downto 0) | IM(35 downto 0)]
        valid_in  : in  std_logic;  -- Indicates that data_in is valid

        -- Output Data Interface
        vector_out : out cvector;   -- Assembled vector
        done_out   : out std_logic  -- High when vector is fully assembled (latched until reset)
    );
end entity assemble_vector;

architecture rtl of assemble_vector is

    -- Define state machine states
    type state_t is (IDLE, RECEIVING, DONE);
    signal current_state, next_state : state_t;

    -- Constant definitions for data slicing and zero values
    constant F_LEN      : integer := fixed64'length; -- 36
    constant RE_HIGH    : integer := (2 * F_LEN) - 1;  -- 71
    constant RE_LOW     : integer := F_LEN;            -- 36
    constant IM_HIGH    : integer := F_LEN - 1;        -- 35
    constant IM_LOW     : integer := 0;                -- 0

    constant ZERO_fixed64  : fixed64 := to_sfixed(0.0, fixed64'high, fixed64'low);
    constant ZERO_cfixed64 : cfixed64 := (re => ZERO_fixed64, im => ZERO_fixed64);

    -- Internal storage for the vector, defaulting all elements to zero.
    signal internal_vector : cvector := (others => ZERO_cfixed64);

    -- Single index counter for the vector elements
    signal index_cnt : natural range 0 to dimension - 1;

begin

    ----------------------------------------------------------------------------
    -- State Register Process (Synchronous)
    ----------------------------------------------------------------------------
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

    ----------------------------------------------------------------------------
    -- Index Counter and Internal Vector Update Process (Synchronous)
    ----------------------------------------------------------------------------
    process(clk)
        variable temp_cfixed64 : cfixed64;
        variable temp_re_slv   : std_logic_vector(F_LEN - 1 downto 0);
        variable temp_im_slv   : std_logic_vector(F_LEN - 1 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                index_cnt       <= 0;
                internal_vector <= (others => ZERO_cfixed64);
            else
                if current_state = RECEIVING and valid_in = '1' then
                    -- Slice input data into real and imaginary parts
                    temp_re_slv := data_in(RE_HIGH downto RE_LOW);
                    temp_im_slv := data_in(IM_HIGH downto IM_LOW);

                    -- Convert the slices to fixed-point numbers and form a complex value
                    temp_cfixed64.re := to_sfixed(signed(temp_re_slv), fixed64'high, fixed64'low);
                    temp_cfixed64.im := to_sfixed(signed(temp_im_slv), fixed64'high, fixed64'low);

                    -- Store the converted value in the current element of the vector
                    internal_vector(index_cnt) <= temp_cfixed64;

                    -- Update index counter unless the current element is the last one
                    if index_cnt < dimension - 1 then
                        index_cnt <= index_cnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Next State and Output Logic Process (Combinatorial)
    ----------------------------------------------------------------------------
    process(current_state, valid_in, index_cnt)
    begin
        -- Default assignments
        next_state  <= current_state;
        done_out    <= '0';
        vector_out  <= internal_vector;

        case current_state is
            when IDLE =>
                if valid_in = '1' then
                    if dimension = 0 then
                        next_state <= IDLE;  -- Nothing to do for a zero-dimension vector
                    elsif dimension = 1 then  -- Special case: only one element to capture
                        next_state <= DONE;
                    else
                        next_state <= RECEIVING;
                    end if;
                else
                    next_state <= IDLE;
                end if;

            when RECEIVING =>
                if valid_in = '1' then
                    if index_cnt = dimension - 1 then
                        next_state <= DONE;
                    else
                        next_state <= RECEIVING;
                    end if;
                else
                    next_state <= RECEIVING;
                end if;

            when DONE =>
                done_out   <= '1';  -- Signal that the vector is fully assembled
                next_state <= DONE;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

end architecture rtl;

