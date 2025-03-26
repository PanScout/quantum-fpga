library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity Calculate_Norm_And_Compare is
    port (
        -- Input matrix: dimension = numBasisStates × numBasisStates (from qTypes)
        A       : in  cmatrixHigh;
        
        -- Output: '1' if THETA > infinityNorm(A), else '0'
        isBelow : out std_logic;
	InfinityNormOut : out cfixedHigh
    );
end entity Calculate_Norm_And_Compare;

architecture structural of Calculate_Norm_And_Compare is

    ----------------------------------------------------------------------------
    -- 1) Internal signals
    ----------------------------------------------------------------------------
    signal rowSums    : cvectorHigh; -- from Absolute_Row_Summation
    signal largestVal : fixedHigh;   -- from Max_Of_CVector

    ----------------------------------------------------------------------------
    -- 2) Define the constant THETA
    ----------------------------------------------------------------------------
    -- Adjust these bounds (40 downto -64) as needed to match 'fixedHigh'
    constant THETA : fixedHigh := b"0000000000000000000000111101010000100101100011111111111011000000";

    ----------------------------------------------------------------------------
    -- 3) Component declarations
    ----------------------------------------------------------------------------
    component Absolute_Row_Summation is
        port (
            A       : in  cmatrixHigh;
            rowSums : out cvectorHigh
        );
    end component;

    component Max_Of_CVector is
        port (
            inputVector  : in  cvectorHigh;
            largestValue : out fixedHigh
        );
    end component;

begin

    ----------------------------------------------------------------------------
    -- 4) Instantiate Absolute_Row_Summation
    ----------------------------------------------------------------------------
    sum_inst: Absolute_Row_Summation
        port map (
            A       => A,
            rowSums => rowSums
        );

    ----------------------------------------------------------------------------
    -- 5) Instantiate Max_Of_CVector
    ----------------------------------------------------------------------------
    norm_inst: Max_Of_CVector
        port map (
            inputVector  => rowSums,
            largestValue => largestVal
        );

    ----------------------------------------------------------------------------
    -- 6) Compare the resulting infinity norm with THETA
    ----------------------------------------------------------------------------
    -- "If THETA > largestVal then output '1' else '0'"
    isBelow <= '1' when THETA > largestVal else '0';
    infinityNormOut.re <= largestVal;
    infinityNormOut.im <= b"0000000000000000000000000000000000000000000000000000000000000000";

end architecture structural;




