library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;

use work.qTypes.all;

entity Ceiling_Of_Log2 is
    port (
        scalar : in cfixedHigh;
        result : out cfixedHigh
    );
end Ceiling_Of_Log2;

architecture Structural of Ceiling_Of_Log2 is
    -- Threshold constants for 2^(n-1) where n is output value
    constant TH_25 : fixedHigh := to_sfixed(2**24, fixedHigh'high, fixedHigh'low);
    constant TH_24 : fixedHigh := to_sfixed(2**23, fixedHigh'high, fixedHigh'low);
    constant TH_23 : fixedHigh := to_sfixed(2**22, fixedHigh'high, fixedHigh'low);
    constant TH_22 : fixedHigh := to_sfixed(2**21, fixedHigh'high, fixedHigh'low);
    constant TH_21 : fixedHigh := to_sfixed(2**20, fixedHigh'high, fixedHigh'low);
    constant TH_20 : fixedHigh := to_sfixed(2**19, fixedHigh'high, fixedHigh'low);
    constant TH_19 : fixedHigh := to_sfixed(2**18, fixedHigh'high, fixedHigh'low);
    constant TH_18 : fixedHigh := to_sfixed(2**17, fixedHigh'high, fixedHigh'low);
    constant TH_17 : fixedHigh := to_sfixed(2**16, fixedHigh'high, fixedHigh'low);
    constant TH_16 : fixedHigh := to_sfixed(2**15, fixedHigh'high, fixedHigh'low);
    constant TH_15 : fixedHigh := to_sfixed(2**14, fixedHigh'high, fixedHigh'low);
    constant TH_14 : fixedHigh := to_sfixed(2**13, fixedHigh'high, fixedHigh'low);
    constant TH_13 : fixedHigh := to_sfixed(2**12, fixedHigh'high, fixedHigh'low);
    constant TH_12 : fixedHigh := to_sfixed(2**11, fixedHigh'high, fixedHigh'low);
    constant TH_11 : fixedHigh := to_sfixed(2**10, fixedHigh'high, fixedHigh'low);
    constant TH_10 : fixedHigh := to_sfixed(2**9,  fixedHigh'high, fixedHigh'low);
    constant TH_9  : fixedHigh := to_sfixed(2**8,  fixedHigh'high, fixedHigh'low);
    constant TH_8  : fixedHigh := to_sfixed(2**7,  fixedHigh'high, fixedHigh'low);
    constant TH_7  : fixedHigh := to_sfixed(2**6,  fixedHigh'high, fixedHigh'low);
    constant TH_6  : fixedHigh := to_sfixed(2**5,  fixedHigh'high, fixedHigh'low);
    constant TH_5  : fixedHigh := to_sfixed(2**4,  fixedHigh'high, fixedHigh'low);
    constant TH_4  : fixedHigh := to_sfixed(2**3,  fixedHigh'high, fixedHigh'low);
    constant TH_3  : fixedHigh := to_sfixed(2**2,  fixedHigh'high, fixedHigh'low);
    constant TH_2  : fixedHigh := to_sfixed(2**1,  fixedHigh'high, fixedHigh'low);
    constant TH_1  : fixedHigh := to_sfixed(2**0,  fixedHigh'high, fixedHigh'low);
begin
    -- Ceiling log2 calculation using priority-encoded thresholds
    result.re <= 
        to_sfixed(25, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_25 else
        to_sfixed(24, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_24 else
        to_sfixed(23, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_23 else
        to_sfixed(22, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_22 else
        to_sfixed(21, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_21 else
        to_sfixed(20, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_20 else
        to_sfixed(19, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_19 else
        to_sfixed(18, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_18 else
        to_sfixed(17, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_17 else
        to_sfixed(16, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_16 else
        to_sfixed(15, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_15 else
        to_sfixed(14, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_14 else
        to_sfixed(13, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_13 else
        to_sfixed(12, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_12 else
        to_sfixed(11, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_11 else
        to_sfixed(10, fixedHigh'high, fixedHigh'low) when scalar.re >= TH_10 else
        to_sfixed(9,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_9  else
        to_sfixed(8,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_8  else
        to_sfixed(7,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_7  else
        to_sfixed(6,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_6  else
        to_sfixed(5,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_5  else
        to_sfixed(4,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_4  else
        to_sfixed(3,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_3  else
        to_sfixed(2,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_2  else
        to_sfixed(1,  fixedHigh'high, fixedHigh'low) when scalar.re >= TH_1  else
        to_sfixed(0,  fixedHigh'high, fixedHigh'low);

    -- Imaginary component always zero
    result.im <= to_sfixed(0, fixedHigh'high, fixedHigh'low);
end Structural;
