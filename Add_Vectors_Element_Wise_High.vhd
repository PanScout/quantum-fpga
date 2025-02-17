library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;  -- Use your custom package

entity Add_Vectors_Element_Wise_High is
    port(
        a : in  cvectorHigh;  -- Input complex vector 1
        b : in  cvectorHigh;  -- Input complex vector 2
        c : out cvectorHigh   -- Output complex vector (a + b)
    );
end entity;

architecture concurrent_arch of Add_Vectors_Element_Wise_High is
begin
    -- Generate adders for each element in the cvector
    gen_adders_High : for i in 0 to numBasisStates-1 generate
        -- Real part addition
        --c(i).re <= resize (a(i).re + b(i).re, fixedHigh'high, fixedHigh'low);
        c(i).re <= std_logic_vector(resize(signed(a(i).re) + signed(b(i).re), 64));
        -- Imaginary part addition
        --c(i).im <= resize (a(i).im + b(i).im, fixedHigh'high, fixedHigh'low);
        c(i).im <= std_logic_vector(resize(signed(a(i).im) + signed(b(i).im), 64));
    end generate gen_adders_High;
end architecture;
