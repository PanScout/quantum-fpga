library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;  -- Use your custom package

entity cvector_adder is
    port(
        a : in  cvector;  -- Input complex vector 1
        b : in  cvector;  -- Input complex vector 2
        c : out cvector   -- Output complex vector (a + b)
    );
end entity;

architecture concurrent_arch of cvector_adder is
begin
    -- Generate adders for each element in the cvector
    gen_adders : for i in 0 to numBasisStates-1 generate
        -- Real part addition
        c(i).re <= resize (a(i).re + b(i).re, fixed'high, fixed'low);
        -- Imaginary part addition
        c(i).im <= resize (a(i).im + b(i).im, fixed'high, fixed'low);
    end generate gen_adders;
end architecture;
