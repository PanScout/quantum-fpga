library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity normAndCompare is
    Port (
        A       : in  cmatrixHigh;  -- Input matrix (N x N) in high precision
        norm_out: out fixedHigh     -- Output: 1-norm (maximum column sum) in high precision
    );
end normAndCompare;

architecture Behavioral of normAndCompare is

    ----------------------------------------------------------------------------
    -- Function: cabs
    --
    -- Returns the absolute value (magnitude) of a complex fixed-point number.
    -- Since each number is assumed to be either purely real or purely imaginary,
    -- the magnitude is simply the sum of the absolute values of the components.
    ----------------------------------------------------------------------------
    function cabs(x : cfixedHigh) return fixedHigh is
    begin
        return abs(x.re) + abs(x.im);
    end function cabs;

begin

    ----------------------------------------------------------------------------
    -- Process: Compute 1-Norm of the Matrix
    --
    -- The 1-norm is defined as the maximum over columns of the sum of the
    -- absolute values of the entries in that column.
    ----------------------------------------------------------------------------
    process(A)
        variable col_sum : fixedHigh;
        variable max_sum : fixedHigh;
    begin
        -- Initialize max_sum to zero in high precision.
        max_sum := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);

        -- Loop over each column.
        for col in A(0)'range loop
            col_sum := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
            -- Sum the absolute values for all rows in this column.
            for row in A'range loop
                col_sum := col_sum + cabs(A(row)(col));
            end loop;
            -- Update maximum if this column sum is larger.
            if col_sum > max_sum then
                max_sum := col_sum;
            end if;
        end loop;

        norm_out <= max_sum;
    end process;

end Behavioral;

