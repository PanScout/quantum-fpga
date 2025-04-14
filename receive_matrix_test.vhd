library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Include your custom packages so that fixed64, cmatrix, dimension, etc. are defined.
use work.fixed_pkg.ALL;
use work.qTypes.ALL; -- Make sure cmatrix, cfixed64, fixed64 are defined here

entity receive_matrix_test is
    port (
        -- Input Ports (Unchanged)
        clk       : in  std_logic;
        reset     : in  std_logic;
        enable    : in  std_logic;
        SCLK      : in  std_logic;
        SS        : in  std_logic;
        MOSI      : in  std_logic;

        -- Output Ports (matrix_out removed, spi_valid_out added)
        done_out      : out std_logic;
        spi_valid_out : out std_logic; -- <<< NEW PORT ADDED

        -- Ports for 7-Segment Display (Unchanged)
        sel_num   : in  std_logic_vector(1 downto 0); -- Selects matrix element: "00"(0,0), "01"(0,1), "10"(1,0), "11"(1,1)
        seg_out_7 : out std_logic_vector(6 downto 0); -- MS Digit
        seg_out_6 : out std_logic_vector(6 downto 0);
        seg_out_5 : out std_logic_vector(6 downto 0);
        seg_out_4 : out std_logic_vector(6 downto 0);
        seg_out_3 : out std_logic_vector(6 downto 0);
        seg_out_2 : out std_logic_vector(6 downto 0);
        seg_out_1 : out std_logic_vector(6 downto 0);
        seg_out_0 : out std_logic_vector(6 downto 0)  -- LS Digit
    );
end receive_matrix_test;

architecture top of receive_matrix_test is

    -- Constants (Unchanged)
    constant DATA_WIDTH : integer := 2 * fixed64'length;
    constant ZERO_fixed64  : fixed64 := to_sfixed(0.0, fixed64'high, fixed64'low);
    constant ZERO_cfixed64 : cfixed64 := (re => ZERO_fixed64, im => ZERO_fixed64);

    -- Internal signals connecting the SPI receiver to the matrix assembler. (Unchanged)
    signal spi_data  : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal spi_valid : std_logic; -- Internal signal driven by spi_receive

    -- *** New internal signal to hold the assembled matrix ***
    signal internal_matrix_signal : cmatrix; -- Assuming type cmatrix is array(0 to 1, 0 to 1) of cfixed64

    -- Internal signals for 7-segment display logic (Unchanged)
    signal selected_cfixed       : cfixed64;
    signal selected_real_fixed   : fixed64;
    signal selected_real_slv     : std_logic_vector(fixed64'length - 1 downto 0);
    signal selected_real_upper_32: std_logic_vector(31 downto 0);
    signal hex_digit_7 : std_logic_vector(3 downto 0);
    signal hex_digit_6 : std_logic_vector(3 downto 0);
    signal hex_digit_5 : std_logic_vector(3 downto 0);
    signal hex_digit_4 : std_logic_vector(3 downto 0);
    signal hex_digit_3 : std_logic_vector(3 downto 0);
    signal hex_digit_2 : std_logic_vector(3 downto 0);
    signal hex_digit_1 : std_logic_vector(3 downto 0);
    signal hex_digit_0 : std_logic_vector(3 downto 0);

begin

    -- Instance of the SPI receiver (Port map is unchanged, still drives internal spi_valid)
    spi_receive_inst : entity work.spi_receive
        generic map (
            NUM_BITS => DATA_WIDTH
        )
        port map (
            clk       => clk,
            reset     => reset,
            enable    => enable,
            SCLK      => SCLK,
            SS        => SS,
            MOSI      => MOSI,
            NUM       => spi_data,
            spi_valid => spi_valid -- Connects to the internal signal
        );

    -- Instance of the matrix assembler (Unchanged Port Map)
    assemble_matrix_inst : entity work.assemble_matrix
        port map (
            clk        => clk,
            reset      => reset,
            data_in    => spi_data,
            valid_in   => spi_valid, -- Reads from the internal signal
            matrix_out => internal_matrix_signal,
            done_out   => done_out
        );

    -- *** NEW CONCURRENT ASSIGNMENT ***
    -- Connect the internal spi_valid signal to the new top-level output port
    spi_valid_out <= spi_valid;

    -- *** 7-Segment Display Logic (Modified Process Sensitivity and Reads) ***

    -- 1. Select the cfixed64 element based on sel_num (Combinatorial)
    --    Reads from the internal signal now.
    process(sel_num, internal_matrix_signal) -- Sensitivity list updated
    begin
        case sel_num is
            when "00" => selected_cfixed <= internal_matrix_signal(0)(0); -- Read from internal signal
            when "01" => selected_cfixed <= internal_matrix_signal(0)(1); -- Read from internal signal
            when "10" => selected_cfixed <= internal_matrix_signal(1)(0); -- Read from internal signal
            when "11" => selected_cfixed <= internal_matrix_signal(1)(1); -- Read from internal signal
            when others => selected_cfixed <= ZERO_cfixed64;
        end case;
    end process;

    -- 2. Extract the Real part (Unchanged)
    selected_real_fixed <= selected_cfixed.re;

    -- 3. Convert Real part (fixed64) to std_logic_vector (Unchanged)
    selected_real_slv <= to_slv(selected_real_fixed);

    -- 4. Extract upper 32 bits (Unchanged)
    selected_real_upper_32 <= selected_real_slv(35 downto 4);

    -- 5. Slice the 32 bits into 8 hex digits (Unchanged)
    hex_digit_7 <= selected_real_upper_32(31 downto 28);
    hex_digit_6 <= selected_real_upper_32(27 downto 24);
    hex_digit_5 <= selected_real_upper_32(23 downto 20);
    hex_digit_4 <= selected_real_upper_32(19 downto 16);
    hex_digit_3 <= selected_real_upper_32(15 downto 12);
    hex_digit_2 <= selected_real_upper_32(11 downto 8);
    hex_digit_1 <= selected_real_upper_32(7 downto 4);
    hex_digit_0 <= selected_real_upper_32(3 downto 0);

    -- 6. Instantiate the hex_to_7seg converters (Unchanged)
    disp7 : entity work.hex_to_7seg port map (hex_in => hex_digit_7, seg_out => seg_out_7);
    disp6 : entity work.hex_to_7seg port map (hex_in => hex_digit_6, seg_out => seg_out_6);
    disp5 : entity work.hex_to_7seg port map (hex_in => hex_digit_5, seg_out => seg_out_5);
    disp4 : entity work.hex_to_7seg port map (hex_in => hex_digit_4, seg_out => seg_out_4);
    disp3 : entity work.hex_to_7seg port map (hex_in => hex_digit_3, seg_out => seg_out_3);
    disp2 : entity work.hex_to_7seg port map (hex_in => hex_digit_2, seg_out => seg_out_2);
    disp1 : entity work.hex_to_7seg port map (hex_in => hex_digit_1, seg_out => seg_out_1);
    disp0 : entity work.hex_to_7seg port map (hex_in => hex_digit_0, seg_out => seg_out_0);

end architecture top;