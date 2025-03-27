library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.fixed64.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity Calculate_Norm_And_Compare is
    port (
        -- Input matrix: dimension = dimension × dimension (from qTypes)
        A       : in  cmatrix;
        
        -- Output: '1' if THETA > infinityNorm(A), else '0'
        isBelow : out std_logic;
	InfinityNormOut : out cfixed64
    );
end entity Calculate_Norm_And_Compare;

architecture structural of Calculate_Norm_And_Compare is

    ----------------------------------------------------------------------------
    -- 1) Internal signals
    ----------------------------------------------------------------------------
    signal rowSums    : cvector; -- from Absolute_Row_Summation
    signal largestVal : fixed64;   -- from Max_Of_CVector

    ----------------------------------------------------------------------------
    -- 2) Define the constant THETA
    ----------------------------------------------------------------------------
    -- Adjust these bounds (40 downto -64) as needed to match 'fixed64'
    constant THETA : fixed64 := b"0000000000000000000000111101010000100101100011111111111011000000";

    ----------------------------------------------------------------------------
    -- 3) Component declarations
    ----------------------------------------------------------------------------
    component Absolute_Row_Summation is
        port (
            A       : in  cmatrix;
            rowSums : out cvector
        );
    end component;

    component Max_Of_CVector is
        port (
            inputVector  : in  cvector;
            largestValue : out fixed64
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




