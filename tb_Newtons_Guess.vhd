library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all; -- Added for abs function if needed in verification

-- Make sure these packages contain the definitions for:
-- cmatrix : type array (0 to dimension-1, 0 to dimension-1) of complex_num;
-- complex_num : type record re, im : sfixed(fixed64'high downto fixed64'low); end record;
-- fixed64 : subtype sfixed(X downto Y); -- Define appropriate range X, Y
-- to_sfixed, to_real functions
use work.fixed_pkg.all; -- Assuming fixed-point types and conversions are here
use work.qTypes.all;    -- Assuming cmatrix and complex_num types are here

entity tb_Newtons_Guess is
    -- No ports needed for a self-contained testbench
end tb_Newtons_Guess;

architecture Behavioral of tb_Newtons_Guess is

    -- Component Declaration (Matches the entity being tested)
    component Newtons_Guess is
        Port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            A         : in  cmatrix;  -- Input complex matrix
            scaled_AT : out cmatrix   -- Output scaled matrix (likely inverse or similar)
        );
    end component;

    -- Constants
    constant dimension     : integer := 2; -- Define matrix dimension (2x2)
    constant CLK_PERIOD    : time    := 10 ns; -- Example clock period
    constant RESET_DURATION: time    := 55 ns; -- Example reset duration
    constant TOLERANCE     : real    := 1.0e-9; -- Tolerance for verification checks

    -- Signals for Testbench
    signal clk   : std_logic := '0';
    signal reset : std_logic := '1'; -- Start in reset

    -- Signals to connect to the UUT (Unit Under Test)
    signal A_input   : cmatrix; -- Renamed to avoid conflict with constants if needed
    signal scaled_AT : cmatrix;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Newtons_Guess
        port map (
            clk       => clk,
            reset     => reset,
            A         => A_input,
            scaled_AT => scaled_AT
        );

    -- Clock Generation Process
    clk_process: process
    begin
        loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Reset Generation Process
    reset_process: process
    begin
        reset <= '1'; -- Assert reset
        wait for RESET_DURATION;
        reset <= '0'; -- Deassert reset
        wait;         -- Wait indefinitely
    end process;

    -- Stimulus and Verification Process
    stim_proc: process
        -- ================================================================
        -- == USER INPUT SECTION: Define your 2x2 complex matrix 'A' here ==
        -- ================================================================
        -- A = | A(0)(0)  A(0)(1) |
        --     | A(1)(0)  A(1)(1) |
        -- where A(i)(j) = Aij_RE + Aij_IM * i

        -- Element A(0)(0)
        constant A00_RE : real := -120.0;
        constant A00_IM : real := 0.0292969;

        -- Element A(0)(1)
        constant A01_RE : real := -0.0292969;
        constant A01_IM : real := 0.00000572205;

        -- Element A(1)(0)
        constant A10_RE : real := 0.0;
        constant A10_IM : real := 0.0;

        -- Element A(1)(1)
        constant A11_RE : real := -120.0;
        constant A11_IM : real := 0.0292969;

        -- ================================================================
        -- == Verification Variables                                   ==
        -- ================================================================
        -- Variables to hold expected values (YOU NEED TO CALCULATE THESE)
        variable expected_scaled_AT : cmatrix;
        variable actual_re, actual_im : real;
        variable expected_re, expected_im : real;
        variable error_margin_re, error_margin_im : real;
        variable check_passed : boolean := true;

    begin
        report "Starting Testbench for Newtons_Guess...";

        -- Wait for reset to deassert
        wait until reset = '0';
        wait for CLK_PERIOD * 2; -- Wait a couple of cycles after reset

        -- ----------------------------------------
        -- Apply the Input Matrix A
        -- ----------------------------------------
        report "Applying input matrix A...";

        -- Assign values using the constants defined above
        -- Convert real numbers to sfixed format using your package's function
        -- Ensure 'fixed64' is correctly defined in your fixed_pkg or qTypes
        A_input(0)(0).re <= to_sfixed(A00_RE, fixed64'high, fixed64'low);
        A_input(0)(0).im <= to_sfixed(A00_IM, fixed64'high, fixed64'low);

        A_input(0)(1).re <= to_sfixed(A01_RE, fixed64'high, fixed64'low);
        A_input(0)(1).im <= to_sfixed(A01_IM, fixed64'high, fixed64'low);

        A_input(1)(0).re <= to_sfixed(A10_RE, fixed64'high, fixed64'low);
        A_input(1)(0).im <= to_sfixed(A10_IM, fixed64'high, fixed64'low);

        A_input(1)(1).re <= to_sfixed(A11_RE, fixed64'high, fixed64'low);
        A_input(1)(1).im <= to_sfixed(A11_IM, fixed64'high, fixed64'low);

        -- Wait for the DUT to process the input
        -- The required wait time depends on the latency of the Newtons_Guess component.
        -- Adjust this wait time accordingly.
        wait for CLK_PERIOD * 10; -- Example: Wait 10 clock cycles

        -- ----------------------------------------
        -- Verify the Output Matrix scaled_AT
        -- ----------------------------------------
        report "Verifying output matrix scaled_AT...";

        -- ========================================================================
        -- == USER VERIFICATION SECTION: Update expected values based on inputs ==
        -- ========================================================================
        -- Calculate or define the EXPECTED values for scaled_AT based on the
        -- A_input matrix provided above and the algorithm implemented in
        -- Newtons_Guess.
        --
        -- Example structure (replace with your actual expected values):
        -- expected_scaled_AT(0)(0).re := to_sfixed( EXPECTED_00_RE , fixed64'high, fixed64'low);
        -- expected_scaled_AT(0)(0).im := to_sfixed( EXPECTED_00_IM , fixed64'high, fixed64'low);
        -- expected_scaled_AT(0)(1).re := to_sfixed( EXPECTED_01_RE , fixed64'high, fixed64'low);
        -- expected_scaled_AT(0)(1).im := to_sfixed( EXPECTED_01_IM , fixed64'high, fixed64'low);
        -- expected_scaled_AT(1)(0).re := to_sfixed( EXPECTED_10_RE , fixed64'high, fixed64'low);
        -- expected_scaled_AT(1)(0).im := to_sfixed( EXPECTED_10_IM , fixed64'high, fixed64'low);
        -- expected_scaled_AT(1)(1).re := to_sfixed( EXPECTED_11_RE , fixed64'high, fixed64'low);
        -- expected_scaled_AT(1)(1).im := to_sfixed( EXPECTED_11_IM , fixed64'high, fixed64'low);

        -- !!! Placeholder: Assign dummy expected values for now !!!
        -- !!! Replace these with your actual calculated expected values !!!
        expected_scaled_AT(0)(0).re := to_sfixed( 0.1 , fixed64'high, fixed64'low); -- DUMMY
        expected_scaled_AT(0)(0).im := to_sfixed( 0.2 , fixed64'high, fixed64'low); -- DUMMY
        expected_scaled_AT(0)(1).re := to_sfixed( 0.3 , fixed64'high, fixed64'low); -- DUMMY
        expected_scaled_AT(0)(1).im := to_sfixed( 0.4 , fixed64'high, fixed64'low); -- DUMMY
        expected_scaled_AT(1)(0).re := to_sfixed( 0.5 , fixed64'high, fixed64'low); -- DUMMY
        expected_scaled_AT(1)(0).im := to_sfixed( 0.6 , fixed64'high, fixed64'low); -- DUMMY
        expected_scaled_AT(1)(1).re := to_sfixed( 0.7 , fixed64'high, fixed64'low); -- DUMMY
        expected_scaled_AT(1)(1).im := to_sfixed( 0.8 , fixed64'high, fixed64'low); -- DUMMY
        report "WARNING: Using DUMMY expected values for verification. Please update." severity warning;


        -- Loop through the output matrix and compare with expected values
        for i in 0 to dimension - 1 loop
            for j in 0 to dimension - 1 loop
                -- Convert actual and expected sfixed to real for comparison
                actual_re := to_real(scaled_AT(i)(j).re);
                actual_im := to_real(scaled_AT(i)(j).im);
                expected_re := to_real(expected_scaled_AT(i)(j).re);
                expected_im := to_real(expected_scaled_AT(i)(j).im);

                -- Calculate absolute error
                error_margin_re := abs(actual_re - expected_re);
                error_margin_im := abs(actual_im - expected_im);

                -- Check Real Part
                if error_margin_re >= TOLERANCE then
                    report "VERIFICATION FAILED (Real Part): Mismatch at (" & integer'image(i) & "," & integer'image(j) & ")" &
                           " Expected: " & real'image(expected_re) &
                           " Got: " & real'image(actual_re) &
                           " Error: " & real'image(error_margin_re)
                        severity error;
                    check_passed := false;
                end if;

                -- Check Imaginary Part
                 if error_margin_im >= TOLERANCE then
                    report "VERIFICATION FAILED (Imaginary Part): Mismatch at (" & integer'image(i) & "," & integer'image(j) & ")" &
                           " Expected: " & real'image(expected_im) &
                           " Got: " & real'image(actual_im) &
                           " Error: " & real'image(error_margin_im)
                        severity error;
                    check_passed := false;
                end if;

            end loop;
        end loop;

        -- Final Test Report
        if check_passed then
            report "Test completed successfully!";
        else
            report "Test FAILED. See error messages above.";
        end if;

        -- Stop the simulation
        report "Simulation finished." severity failure; -- Use severity failure to stop most simulators
        wait; -- Wait indefinitely

    end process stim_proc;

end Behavioral;
