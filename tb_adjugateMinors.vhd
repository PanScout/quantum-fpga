library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;  -- Contains definitions for cmatrixHigh, cvectorHigh, and cfixedHigh

entity tb_AdjugateMinors is
end tb_AdjugateMinors;

architecture Behavioral of tb_AdjugateMinors is

    -- Signal declarations for the 4×4 input matrix and the output minors vector.
    signal A      : cmatrixHigh;
    signal minors : cvectorHigh;

    -- Convenience constants for 1 and 0 in the fixed-point representation.
    constant one_sfixed  : sfixed(fixedHigh'high downto fixedHigh'low) :=
                           to_sfixed(1, fixedHigh'high, fixedHigh'low);
    constant zero_sfixed : sfixed(fixedHigh'high downto fixedHigh'low) :=
                           to_sfixed(0, fixedHigh'high, fixedHigh'low);

begin

    ----------------------------------------------------------------------------
    -- Instantiate the AdjugateMinors component.
    ----------------------------------------------------------------------------
    uut: entity work.Adj_SubDetermiants
      port map (
        A      => A,
        minors => minors
      );

    ----------------------------------------------------------------------------
    -- Stimulus Process
    ----------------------------------------------------------------------------
    stim: process
    begin
        -- Test Case: Identity Matrix.
        -- The 4×4 identity matrix is defined as:
        --   [1 0 0 0;
        --    0 1 0 0;
        --    0 0 1 0;
        --    0 0 0 1]
        --
        -- When computing the minors corresponding to the first row:
        -- - For j = 0, we remove row0 and column0, yielding a 3×3 identity (determinant 1).
        -- - For j = 1, 2, 3, the resulting 3×3 matrices are singular (determinant 0).
        A <= (
            0 => (0 => (re => one_sfixed,  im => zero_sfixed),
                  1 => (re => zero_sfixed, im => zero_sfixed),
                  2 => (re => zero_sfixed, im => zero_sfixed),
                  3 => (re => zero_sfixed, im => zero_sfixed)),
            1 => (0 => (re => zero_sfixed, im => zero_sfixed),
                  1 => (re => one_sfixed,  im => zero_sfixed),
                  2 => (re => zero_sfixed, im => zero_sfixed),
                  3 => (re => zero_sfixed, im => zero_sfixed)),
            2 => (0 => (re => zero_sfixed, im => zero_sfixed),
                  1 => (re => zero_sfixed, im => zero_sfixed),
                  2 => (re => one_sfixed,  im => zero_sfixed),
                  3 => (re => zero_sfixed, im => zero_sfixed)),
            3 => (0 => (re => zero_sfixed, im => zero_sfixed),
                  1 => (re => zero_sfixed, im => zero_sfixed),
                  2 => (re => zero_sfixed, im => zero_sfixed),
                  3 => (re => one_sfixed,  im => zero_sfixed))
        );
        
        wait for 100 ns;  -- Wait for the component to process the input
        
        ----------------------------------------------------------------------------
        -- Check Expected Results:
        -- Expected minors vector (for the first row cofactors):
        --   minors(0) should be 1 (since det of 3×3 identity = 1 and sign factor = +1),
        --   minors(1), minors(2), minors(3) should be 0.
        ----------------------------------------------------------------------------
        assert (minors(0).re = one_sfixed and minors(0).im = zero_sfixed)
            report "Test failed: Minor[0] is not (1, 0)." severity error;
        assert (minors(1).re = zero_sfixed and minors(1).im = zero_sfixed)
            report "Test failed: Minor[1] is not (0, 0)." severity error;
        assert (minors(2).re = zero_sfixed and minors(2).im = zero_sfixed)
            report "Test failed: Minor[2] is not (0, 0)." severity error;
        assert (minors(3).re = zero_sfixed and minors(3).im = zero_sfixed)
            report "Test failed: Minor[3] is not (0, 0)." severity error;
        
        wait;  -- End simulation
    end process;

end Behavioral;

