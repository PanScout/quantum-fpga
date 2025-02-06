library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity normAndCompare is
    port (
        -- Input matrix: dimension = numBasisStates × numBasisStates (from qTypes)
        A       : in  cmatrixHigh;
        
        -- Output: '1' if THETA > infinityNorm(A), else '0'
        isBelow : out std_logic;
	InfinityNormOut : out fixedHigh
    );
end entity normAndCompare;

architecture structural of normAndCompare is

    ----------------------------------------------------------------------------
    -- 1) Internal signals
    ----------------------------------------------------------------------------
    signal rowSums    : cvectorHigh; -- from matrixRowSummation
    signal largestVal : fixedHigh;   -- from infinityNormComparator

    ----------------------------------------------------------------------------
    -- 2) Define the constant THETA
    ----------------------------------------------------------------------------
    -- Adjust these bounds (40 downto -64) as needed to match 'fixedHigh'
    constant THETA : fixedHigh := to_sfixed(1.0, fixedHigh'high, fixedHigh'low);

    ----------------------------------------------------------------------------
    -- 3) Component declarations
    ----------------------------------------------------------------------------
    component matrixRowSummation is
        port (
            A       : in  cmatrixHigh;
            rowSums : out cvectorHigh
        );
    end component;

    component infinityNormComparator is
        port (
            inputVector  : in  cvectorHigh;
            largestValue : out fixedHigh
        );
    end component;

begin

    ----------------------------------------------------------------------------
    -- 4) Instantiate matrixRowSummation
    ----------------------------------------------------------------------------
    sum_inst: matrixRowSummation
        port map (
            A       => A,
            rowSums => rowSums
        );

    ----------------------------------------------------------------------------
    -- 5) Instantiate infinityNormComparator
    ----------------------------------------------------------------------------
    norm_inst: infinityNormComparator
        port map (
            inputVector  => rowSums,
            largestValue => largestVal
        );

    ----------------------------------------------------------------------------
    -- 6) Compare the resulting infinity norm with THETA
    ----------------------------------------------------------------------------
    -- "If THETA > largestVal then output '1' else '0'"
    isBelow <= '1' when THETA > largestVal else '0';
    infinityNormOut <= largestVal;

end architecture structural;




