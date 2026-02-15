library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity calculate_norm_and_compare is
    port (
        -- Input matrix: dimension = dimension × dimension (from qTypes)
        A       : in  cmatrix;
        
        -- Output: '1' if infinityNorm(A) < THETA, else '0'
        isBelow : out std_logic;
	InfinityNormOut : out csfixed36
    );
end entity calculate_norm_and_compare;

architecture structural of calculate_norm_and_compare is

    ----------------------------------------------------------------------------
    -- 1) Internal signals
    ----------------------------------------------------------------------------
    signal rowSums    : cvector; -- from absolute_row_summation
    signal largestVal : sfixed36;   -- from max_real_part_of_cvector

    ----------------------------------------------------------------------------
    -- 2) Define the constant THETA
    ----------------------------------------------------------------------------
    --constant THETA : sfixed36 := b"000000000000000000000111101010000101"; --1.495585217958292 * 10**-2
	 constant THETA: sfixed36 := to_sfixed(-0.0149558, sfixed36'high, sfixed36'low);

    ----------------------------------------------------------------------------
    -- 3) Component declarations
    ----------------------------------------------------------------------------
    component absolute_row_summation is
        port (
            A       : in  cmatrix;
            rowSums : out cvector
        );
    end component;

    component max_real_part_of_cvector is
        port (
            inputVector  : in  cvector;
            largestValue : out sfixed36
        );
    end component;

begin

    ----------------------------------------------------------------------------
    -- 4) Instantiate absolute_row_summation
    ----------------------------------------------------------------------------
    sum_inst: absolute_row_summation
        port map (
            A       => A,
            rowSums => rowSums
        );

    ----------------------------------------------------------------------------
    -- 5) Instantiate max_real_part_of_cvector
    ----------------------------------------------------------------------------
    norm_inst: max_real_part_of_cvector
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
    infinityNormOut.im <= (others => '0');

end architecture structural;




