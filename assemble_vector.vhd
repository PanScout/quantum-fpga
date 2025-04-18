library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity assemble_vector is
    port (
        -- Clock and Reset
        clk        : in  std_logic;
        reset      : in  std_logic;  -- Active high synchronous reset

        -- Input Data Interface
        data_in    : in  std_logic_vector((2 * fixed64'length) - 1 downto 0);  -- [RE | IM]
        valid_in   : in  std_logic;  -- Indicates that data_in is valid

        -- Output Data Interface
        vector_out : out cvector;     -- Assembled vector
        done_out   : out std_logic    -- High when vector is fully assembled
    );
end entity assemble_vector;

architecture rtl of assemble_vector is

    -- State machine
    type state_t is (IDLE, RECEIVING, DONE);
    signal current_state, next_state : state_t;

    -- Zero constants
    constant ZERO_fixed64  : fixed64  := to_sfixed(0.0, fixed64'high, fixed64'low);
    constant ZERO_cfixed64 : cfixed64 := (re => ZERO_fixed64, im => ZERO_fixed64);

    -- Internal vector storage
    signal internal_vector : cvector := (others => ZERO_cfixed64);

    -- Index counter
    signal index_cnt : natural range 0 to dimension - 1 := 0;

    -- Data‐slice constants
    constant F_LEN   : integer := fixed64'length;   -- 36
    constant RE_HIGH : integer := (2 * F_LEN) - 1;   -- 71
    constant RE_LOW  : integer := F_LEN;             -- 36
    constant IM_HIGH : integer := F_LEN - 1;         -- 35
    constant IM_LOW  : integer := 0;                 -- 0

    -- valid_in edge detection
    signal valid_in_d1          : std_logic := '0';
    signal valid_in_rising_edge : std_logic;

begin

    ----------------------------------------------------------------------------
    -- State Register (synchronous)
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
    -- valid_in Delay Register (for edge detection)
    ----------------------------------------------------------------------------
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

    ----------------------------------------------------------------------------
    -- Combinatorial Edge Detector
    ----------------------------------------------------------------------------
    valid_in_rising_edge <= '1'
        when (valid_in = '1' and valid_in_d1 = '0')
        else '0';

    ----------------------------------------------------------------------------
    -- Data Capture & Index Counter (only in RECEIVING, and during IDLE->RECEIVING first)
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
            elsif current_state /= DONE and valid_in_rising_edge = '1' then
                -- Slice real & imag
                temp_re_slv := data_in(RE_HIGH downto RE_LOW);
                temp_im_slv := data_in(IM_HIGH downto IM_LOW);

                -- Convert to fixed-point
                temp_cfixed64.re := sfixed(temp_re_slv);
                temp_cfixed64.im := sfixed(temp_im_slv);

                -- Store into vector
                internal_vector(index_cnt) <= temp_cfixed64;

                -- Bump index until last element
                if index_cnt < dimension - 1 then
                    index_cnt <= index_cnt + 1;
                end if;
            end if;
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Next State & Output Logic (combinatorial)
    ----------------------------------------------------------------------------
    process(current_state, valid_in_rising_edge, index_cnt, internal_vector)
    begin
        -- Defaults
        next_state <= current_state;
        done_out   <= '0';
        vector_out <= internal_vector;

        case current_state is
            when IDLE =>
                if valid_in_rising_edge = '1' then
                    next_state <= RECEIVING;
                end if;

            when RECEIVING =>
                if valid_in_rising_edge = '1' and index_cnt = dimension - 1 then
                    next_state <= DONE;
                else
                    next_state <= RECEIVING;
                end if;

            when DONE =>
                done_out   <= '1';
                next_state <= DONE;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

end architecture rtl;
