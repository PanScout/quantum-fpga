library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;  -- Use your package with type declarations

entity tb_det is
end tb_det;

architecture Behavioral of tb_det is

    -- Signals for the input matrix and output determinant.
    signal A   : cmatrixHigh;
    signal det : cfixedHigh;
    
    -- Convenience constants for fixed point values.
    constant one_sfixed  : sfixed(fixedHigh'high downto fixedHigh'low) := to_sfixed(1, fixedHigh'high, fixedHigh'low);
    constant zero_sfixed : sfixed(fixedHigh'high downto fixedHigh'low) := to_sfixed(0, fixedHigh'high, fixedHigh'low);
    constant two_sfixed  : sfixed(fixedHigh'high downto fixedHigh'low) := to_sfixed(2, fixedHigh'high, fixedHigh'low);
    constant three_sfixed : sfixed(fixedHigh'high downto fixedHigh'low) := to_sfixed(3, fixedHigh'high, fixedHigh'low);
    constant four_sfixed : sfixed(fixedHigh'high downto fixedHigh'low) := to_sfixed(4, fixedHigh'high, fixedHigh'low);

begin

    ----------------------------------------------------------------------------
    -- Instantiate the DeterminantCalculator component.
    ----------------------------------------------------------------------------
    uut: entity work.Calculate_Matrix_Determinant
        port map (
            A   => A,
            det => det
        );

    ----------------------------------------------------------------------------
    -- Stimulus Process
    ----------------------------------------------------------------------------
    stim: process
    begin
        -- Test Case 1: Identity Matrix.
        -- For the identity matrix, the diagonal elements are 1 and all other
        -- elements are 0, so the expected determinant is 1 + j0.
        A <= (
            0 => (0 => (re => one_sfixed,  im => zero_sfixed),
                  1 => (re => four_sfixed, im => zero_sfixed),
                  2 => (re => two_sfixed, im => zero_sfixed),
                  3 => (re => three_sfixed, im => zero_sfixed)),
            1 => (0 => (re => four_sfixed, im => zero_sfixed),
                  1 => (re => three_sfixed,  im => zero_sfixed),
                  2 => (re => one_sfixed, im => zero_sfixed),
                  3 => (re => two_sfixed, im => zero_sfixed)),
            2 => (0 => (re => four_sfixed, im => zero_sfixed),
                  1 => (re => two_sfixed, im => zero_sfixed),
                  2 => (re => three_sfixed,  im => zero_sfixed),
                  3 => (re => two_sfixed, im => zero_sfixed)),
            3 => (0 => (re => four_sfixed, im => zero_sfixed),
                  1 => (re => four_sfixed, im => zero_sfixed),
                  2 => (re => three_sfixed, im => zero_sfixed),
                  3 => (re => one_sfixed,  im => zero_sfixed))
        );
        
        wait for 100 ns;
        
        -- Optional: Use an assertion to check if the determinant is as expected.
        -- Since the identity matrix has a determinant of 1 + j0, we check for that.
        assert (det.re = one_sfixed and det.im = zero_sfixed)
            report "Test failed: Determinant of identity matrix is not (1, 0)."
            severity error;
        
        -- End simulation.
        wait;
    end process;

end Behavioral;

