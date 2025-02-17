library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;

use work.qTypes.all;

entity Ceiling_Of_Log2 is
    port (
        scalar : in cfixedHigh;
        result : out cfixedHigh
    );
end Ceiling_Of_Log2;

architecture Structural of Ceiling_Of_Log2 is
    -- Threshold constants for 2^(n-1) where n is output value
    --constant TH_25 : fixedHigh := to_sfixed(2**24, fixedHigh'high, fixedHigh'low);
    --constant TH_24 : fixedHigh := to_sfixed(2**23, fixedHigh'high, fixedHigh'low);
    --constant TH_23 : fixedHigh := to_sfixed(2**22, fixedHigh'high, fixedHigh'low);
    --constant TH_22 : fixedHigh := to_sfixed(2**21, fixedHigh'high, fixedHigh'low);
    --constant TH_21 : fixedHigh := to_sfixed(2**20, fixedHigh'high, fixedHigh'low);
    --constant TH_20 : fixedHigh := to_sfixed(2**19, fixedHigh'high, fixedHigh'low);
    --constant TH_19 : fixedHigh := to_sfixed(2**18, fixedHigh'high, fixedHigh'low);
    --constant TH_18 : fixedHigh := to_sfixed(2**17, fixedHigh'high, fixedHigh'low);
    --constant TH_17 : fixedHigh := to_sfixed(2**16, fixedHigh'high, fixedHigh'low);
    --constant TH_16 : fixedHigh := to_sfixed(2**15, fixedHigh'high, fixedHigh'low);
    --constant TH_15 : fixedHigh := to_sfixed(2**14, fixedHigh'high, fixedHigh'low);
    --constant TH_14 : fixedHigh := to_sfixed(2**13, fixedHigh'high, fixedHigh'low);
    --constant TH_13 : fixedHigh := to_sfixed(2**12, fixedHigh'high, fixedHigh'low);
    --constant TH_12 : fixedHigh := to_sfixed(2**11, fixedHigh'high, fixedHigh'low);
    --constant TH_11 : fixedHigh := to_sfixed(2**10, fixedHigh'high, fixedHigh'low);
    --constant TH_10 : fixedHigh := to_sfixed(2**9,  fixedHigh'high, fixedHigh'low);
    --constant TH_9  : fixedHigh := to_sfixed(2**8,  fixedHigh'high, fixedHigh'low);
    --constant TH_8  : fixedHigh := to_sfixed(2**7,  fixedHigh'high, fixedHigh'low);
    --constant TH_7  : fixedHigh := to_sfixed(2**6,  fixedHigh'high, fixedHigh'low);
    --constant TH_6  : fixedHigh := to_sfixed(2**5,  fixedHigh'high, fixedHigh'low);
    --constant TH_5  : fixedHigh := to_sfixed(2**4,  fixedHigh'high, fixedHigh'low);
    --constant TH_4  : fixedHigh := to_sfixed(2**3,  fixedHigh'high, fixedHigh'low);
    --constant TH_3  : fixedHigh := to_sfixed(2**2,  fixedHigh'high, fixedHigh'low);
    --constant TH_2  : fixedHigh := to_sfixed(2**1,  fixedHigh'high, fixedHigh'low);
    --constant TH_1  : fixedHigh := to_sfixed(2**0,  fixedHigh'high, fixedHigh'low);
    constant TH_25 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**24, 64));
    constant TH_24 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**23, 64));
    constant TH_23 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**22, 64));
    constant TH_22 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**21, 64));
    constant TH_21 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**20, 64));
    constant TH_20 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**19, 64));
    constant TH_19 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**18, 64));
    constant TH_18 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**17, 64));
    constant TH_17 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**16, 64));
    constant TH_16 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**15, 64));
    constant TH_15 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**14, 64));
    constant TH_14 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**13, 64));
    constant TH_13 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**12, 64));
    constant TH_12 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**11, 64));
    constant TH_11 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**10, 64));
    constant TH_10 : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**9, 64));
    constant TH_9  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**8, 64));
    constant TH_8  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**7, 64));
    constant TH_7  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**6, 64));
    constant TH_6  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**5, 64));
    constant TH_5  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**4, 64));
    constant TH_4  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**3, 64));
    constant TH_3  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**2, 64));
    constant TH_2  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**1, 64));
    constant TH_1  : std_logic_vector(63 downto 0) := std_logic_vector(to_signed(2**0, 64));

begin
    -- Ceiling log2 calculation using priority-encoded thresholds
    result.re <= 
        --to_sfixed(25, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_25 else
        --to_sfixed(24, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_24 else
        --to_sfixed(23, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_23 else
        --to_sfixed(22, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_22 else
        --to_sfixed(21, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_21 else
        --to_sfixed(20, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_20 else
        --to_sfixed(19, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_19 else
        --to_sfixed(18, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_18 else
        --to_sfixed(17, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_17 else
        --to_sfixed(16, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_16 else
        --to_sfixed(15, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_15 else
        --to_sfixed(14, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_14 else
        --to_sfixed(13, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_13 else
        --to_sfixed(12, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_12 else
        --to_sfixed(11, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_11 else
        --to_sfixed(10, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_10 else
        --to_sfixed(9,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_9  else
        --to_sfixed(8,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_8  else
        --to_sfixed(7,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_7  else
        --to_sfixed(6,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_6  else
        --to_sfixed(5,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_5  else
        --to_sfixed(4,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_4  else
        --to_sfixed(3,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_3  else
        --to_sfixed(2,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_2  else
        --to_sfixed(1,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_1  else
        --to_sfixed(0,  fixedHigh'high, fixedHigh'low);
        std_logic_vector(to_signed(25, 64)) when signed(scalar.re) >= signed(TH_25) else
        std_logic_vector(to_signed(24, 64)) when signed(scalar.re) >= signed(TH_24) else
        std_logic_vector(to_signed(23, 64)) when signed(scalar.re) >= signed(TH_23) else
        std_logic_vector(to_signed(22, 64)) when signed(scalar.re) >= signed(TH_22) else
        std_logic_vector(to_signed(21, 64)) when signed(scalar.re) >= signed(TH_21) else
        std_logic_vector(to_signed(20, 64)) when signed(scalar.re) >= signed(TH_20) else
        std_logic_vector(to_signed(19, 64)) when signed(scalar.re) >= signed(TH_19) else
        std_logic_vector(to_signed(18, 64)) when signed(scalar.re) >= signed(TH_18) else
        std_logic_vector(to_signed(17, 64)) when signed(scalar.re) >= signed(TH_17) else
        std_logic_vector(to_signed(16, 64)) when signed(scalar.re) >= signed(TH_16) else
        std_logic_vector(to_signed(15, 64)) when signed(scalar.re) >= signed(TH_15) else
        std_logic_vector(to_signed(14, 64)) when signed(scalar.re) >= signed(TH_14) else
        std_logic_vector(to_signed(13, 64)) when signed(scalar.re) >= signed(TH_13) else
        std_logic_vector(to_signed(12, 64)) when signed(scalar.re) >= signed(TH_12) else
        std_logic_vector(to_signed(11, 64)) when signed(scalar.re) >= signed(TH_11) else
        std_logic_vector(to_signed(10, 64)) when signed(scalar.re) >= signed(TH_10) else
        std_logic_vector(to_signed(9, 64)) when signed(scalar.re) >= signed(TH_9) else
        std_logic_vector(to_signed(8, 64)) when signed(scalar.re) >= signed(TH_8) else
        std_logic_vector(to_signed(7, 64)) when signed(scalar.re) >= signed(TH_7) else
        std_logic_vector(to_signed(6, 64)) when signed(scalar.re) >= signed(TH_6) else
        std_logic_vector(to_signed(5, 64)) when signed(scalar.re) >= signed(TH_5) else
        std_logic_vector(to_signed(4, 64)) when signed(scalar.re) >= signed(TH_4) else
        std_logic_vector(to_signed(3, 64)) when signed(scalar.re) >= signed(TH_3) else
        std_logic_vector(to_signed(2, 64)) when signed(scalar.re) >= signed(TH_2) else
        std_logic_vector(to_signed(1, 64)) when signed(scalar.re) >= signed(TH_1) else
        std_logic_vector(to_signed(0, 64));

    -- Imaginary component always zero
    --result.im <= to_sfixed(0, fixedHigh'high, fixedHigh'low);
    result.im <= (others => '0');
end Structural;
