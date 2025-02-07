library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Pade_Top_Level is
    Port (
        t      : in  fixedHigh;
        output : out cmatrix
    );
end Pade_Top_Level;

architecture Behavioral of Pade_Top_Level is

    -- Declare a constant Hamiltonian of type cmatrixHigh.
    constant Hamiltonian : cmatrixHigh := (
        others => (others => ( re => to_sfixed(0, fixedHigh'high, fixedHigh'low),
                                im => to_sfixed(0, fixedHigh'high, fixedHigh'low) ))
    );

begin
    -- No additional functionality is defined.
    
    -- (Optional) You may drive the output to a default value if required.
    -- For example:
    -- output <= toCmatrix(Hamiltonian);

end Behavioral;
