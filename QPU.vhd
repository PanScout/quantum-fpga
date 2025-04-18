library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Include any packages needed by sub-modules.
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity QPU is
    Port (
        -- Global signals
        clk     : in  std_logic;
        reset   : in  std_logic;     -- Active High Reset
        enable  : in  std_logic;     -- NEW: Mode Control (1=Receive, 0=Transmit)

        -- Matrix SPI Receiver Ports (Now gated internally by 'enable')
        rx_matrix_SCLK     : in  std_logic;
        rx_matrix_SS       : in  std_logic;
        rx_matrix_MOSI     : in  std_logic;
        rx_matrix_NUM      : out std_logic_vector(71 downto 0);
        rx_matrix_spi_valid: out std_logic;

        -- Vector SPI Receiver Ports (Now gated internally by 'enable')
        rx_vector_SCLK     : in  std_logic;
        rx_vector_SS       : in  std_logic;
        rx_vector_MOSI     : in  std_logic;
        rx_vector_NUM      : out std_logic_vector(71 downto 0);
        rx_vector_spi_valid: out std_logic;

        -- SPI Transmitter Ports (Now gated internally by 'enable')
        tx_SCLK     : in  std_logic;
        tx_SS       : in  std_logic;
        MISO        : out std_logic;
        tx_spi_valid: out std_logic; -- Reflects internal transmitter state

        -- Status Output
        psi_matrix_assemble_done : out std_logic -- Existing status signal
        -- REMOVED enable inputs for individual SPI interfaces as they are now controlled by the main 'enable'
        -- rx_matrix_enable   : in  std_logic;
        -- rx_vector_enable   : in  std_logic;
        -- tx_enable          : in  std_logic;
    );
end QPU;

architecture Behavioral of QPU is

    --------------------------------------------------------------------------
    -- Mode Control Signals (Derived from top-level enable and reset)
    --------------------------------------------------------------------------
    signal receive_mode_active  : std_logic; -- High when enable='1' and reset='0'
    signal transmit_mode_active : std_logic; -- High when enable='0' and reset='0'

    --------------------------------------------------------------------------
    -- Internal Signal Declarations (Existing + Transmitter Output)
    --------------------------------------------------------------------------
    signal spi_matrix_data        : std_logic_vector(71 downto 0);
    signal internal_matrix_valid  : std_logic; -- Renamed to avoid conflict

    signal spi_vector_data        : std_logic_vector(71 downto 0);
    signal internal_vector_valid  : std_logic; -- Renamed to avoid conflict

    signal assembled_matrix       : cmatrix;
    signal matrix_done            : std_logic;

    signal assembled_vector       : cvector;
    signal vector_done            : std_logic;

    signal start_evolution        : std_logic;

    signal qte_output_state       : cvector;
    signal qte_output_valid       : std_logic;
    signal qte_t_index            : integer;
    signal qte_evolution_complete : std_logic;

    signal assembled_psi_matrix   : psi_matrix;
    signal internal_psi_asm_done  : std_logic; -- Renamed to avoid conflict

    signal start_disassembly      : std_logic;
    signal disassembled_data      : std_logic_vector((2 * fixed64'length) - 1 downto 0);
    signal disassemble_valid_out  : std_logic;
    signal disassemble_done       : std_logic;

    signal internal_tx_spi_valid  : std_logic; -- Handshake from SPI Transmitter

    -- Removed internal tx_done_pulse - using direct connection
    -- Removed internal enable signals - using mode signals directly

    --------------------------------------------------------------------------
    -- Component Declarations (Keep as before)
    --------------------------------------------------------------------------
    component spi_receive is
        generic ( NUM_BITS : integer := 72 );
        port ( clk, reset, enable, SCLK, SS, MOSI : in std_logic;
               NUM : out std_logic_vector(NUM_BITS-1 downto 0);
               spi_valid : out std_logic );
    end component;

    component assemble_matrix is
         port ( clk, reset : in std_logic;
                data_in  : in  std_logic_vector((2 * fixed64'length) - 1 downto 0);
                valid_in : in  std_logic;
                matrix_out : out cmatrix;
                done_out   : out std_logic );
    end component;

    component assemble_vector is
        port ( clk, reset : in std_logic;
               data_in  : in  std_logic_vector((2 * fixed64'length) - 1 downto 0);
               valid_in : in  std_logic;
               vector_out : out cvector;
               done_out   : out std_logic );
    end component;

    component Quantum_Time_Evolution is
        port ( clk, reset, psiAssemblerDone, matrixAssemblerDone, start_evolution : in std_logic;
               H_in     : in  cmatrix;
               psi_in   : in  cvector;
               output_state : out cvector;
               output_valid : out std_logic;
               current_t_index : out integer;
               evolution_complete : out std_logic );
    end component;

    component assemble_psi_matrix is
        port ( clk, reset, valid_in : in std_logic;
               vector_in    : in  cvector;
               psi_matrix_out : out psi_matrix;
               done_out     : out std_logic );
    end component;

    component disassemble_psi_matrix is
        port ( clk, reset, start, tx_done_pulse_in : in std_logic;
               psi_matrix_in : in  psi_matrix;
               data_out      : out std_logic_vector((2 * fixed64'length) - 1 downto 0);
               valid_out     : out std_logic;
               done_out      : out std_logic );
    end component;

    component spi_transmit is
        generic ( NUM_BITS : integer := 72 );
        port ( clk, enable, SCLK_in, SS_in : in std_logic;
               data_in   : in  std_logic_vector(NUM_BITS - 1 downto 0);
               MISO      : out std_logic;
               spi_valid : out std_logic );
    end component;

begin
    --------------------------------------------------------------------------
    -- Derive Mode Control Signals
    --------------------------------------------------------------------------
    receive_mode_active  <= enable and (not reset);
    transmit_mode_active <= (not enable) and (not reset);

    --------------------------------------------------------------------------
    -- Connect Matrix SPI Receiver Instance (Enabled in Receive Mode)
    --------------------------------------------------------------------------
    rx_matrix_inst: spi_receive
        generic map ( NUM_BITS => 72 )
        port map (
            clk       => clk,
            reset     => reset,           -- Reset overrides everything
            enable    => receive_mode_active, -- Use derived mode signal
            SCLK      => rx_matrix_SCLK,
            SS        => rx_matrix_SS,
            MOSI      => rx_matrix_MOSI,
            NUM       => spi_matrix_data,
            spi_valid => internal_matrix_valid
        );
    -- Drive top-level output ports
    rx_matrix_NUM       <= spi_matrix_data;
    rx_matrix_spi_valid <= internal_matrix_valid;

    --------------------------------------------------------------------------
    -- Connect Vector SPI Receiver Instance (Enabled in Receive Mode)
    --------------------------------------------------------------------------
    rx_vector_inst: spi_receive
        generic map ( NUM_BITS => 72 )
        port map (
            clk       => clk,
            reset     => reset,
            enable    => receive_mode_active, -- Use derived mode signal
            SCLK      => rx_vector_SCLK,
            SS        => rx_vector_SS,
            MOSI      => rx_vector_MOSI,
            NUM       => spi_vector_data,
            spi_valid => internal_vector_valid
        );
    -- Drive top-level output ports
    rx_vector_NUM       <= spi_vector_data;
    rx_vector_spi_valid <= internal_vector_valid;

    --------------------------------------------------------------------------
    -- Assemble Matrix (Activity based on input valid)
    --------------------------------------------------------------------------
    assemble_matrix_inst: assemble_matrix
        port map (
            clk         => clk,
            reset       => reset,
            data_in     => spi_matrix_data,
            valid_in    => internal_matrix_valid, -- Driven by receiver
            matrix_out  => assembled_matrix,
            done_out    => matrix_done
        );

    --------------------------------------------------------------------------
    -- Assemble Vector (Activity based on input valid)
    --------------------------------------------------------------------------
    assemble_vector_inst: assemble_vector
        port map (
            clk         => clk,
            reset       => reset,
            data_in     => spi_vector_data,
            valid_in    => internal_vector_valid, -- Driven by receiver
            vector_out  => assembled_vector,
            done_out    => vector_done
        );

    --------------------------------------------------------------------------
    -- Generate Start Signal for Quantum Evolution
    --------------------------------------------------------------------------
    start_evolution <= '1' when (matrix_done = '1' and vector_done = '1') else '0';

    --------------------------------------------------------------------------
    -- Instantiate Quantum Time Evolution Unit (Activity based on start_evolution)
    --------------------------------------------------------------------------
    Quantum_Time_Evolution_inst: Quantum_Time_Evolution
        port map (
            clk                 => clk,
            reset               => reset,
            psiAssemblerDone    => vector_done,       -- Use internal done signal
            matrixAssemblerDone => matrix_done,       -- Use internal done signal
            start_evolution     => start_evolution,
            H_in                => assembled_matrix,
            psi_in              => assembled_vector,
            output_state        => qte_output_state,
            output_valid        => qte_output_valid,
            current_t_index     => qte_t_index,
            evolution_complete  => qte_evolution_complete
        );

    --------------------------------------------------------------------------
    -- Instantiate Psi Matrix Assembler (Activity based on QTE output valid)
    --------------------------------------------------------------------------
    assemble_psi_matrix_inst: assemble_psi_matrix
        port map (
            clk            => clk,
            reset          => reset,
            vector_in      => qte_output_state,
            valid_in       => qte_output_valid,
            psi_matrix_out => assembled_psi_matrix,
            done_out       => internal_psi_asm_done -- Use internal done signal
        );
    -- Drive top-level output port
    psi_matrix_assemble_done <= internal_psi_asm_done;

    --------------------------------------------------------------------------
    -- Trigger Disassembly When Psi Matrix Assembly is Complete
    --------------------------------------------------------------------------
    start_disassembly <= internal_psi_asm_done; -- Start when assembly finishes

    --------------------------------------------------------------------------
    -- Instantiate Disassemble Psi Matrix Component (Activity based on start)
    --------------------------------------------------------------------------
    disassemble_psi_matrix_inst: disassemble_psi_matrix
        port map (
            clk              => clk,
            reset            => reset,
            start            => start_disassembly,
            psi_matrix_in    => assembled_psi_matrix,
            tx_done_pulse_in => internal_tx_spi_valid, -- Handshake from internal SPI Transmitter
            data_out         => disassembled_data,
            valid_out        => disassemble_valid_out,
            done_out         => disassemble_done
        );

    --------------------------------------------------------------------------
    -- Instantiate SPI Transmit Component (Enabled in Transmit Mode)
    --------------------------------------------------------------------------
    spi_transmit_inst: spi_transmit
        generic map ( NUM_BITS => 72 )
        port map (
            clk         => clk,
            enable      => transmit_mode_active, -- Use derived mode signal
            data_in     => disassembled_data,   -- Fed by disassembler
            SCLK_in     => tx_SCLK,
            SS_in       => tx_SS,
            MISO        => MISO,
            spi_valid   => internal_tx_spi_valid -- Drives internal handshake & top-level output
        );
    -- Drive top-level output port
    tx_spi_valid <= internal_tx_spi_valid;

end Behavioral;
