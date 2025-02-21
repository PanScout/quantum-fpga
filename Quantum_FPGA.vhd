library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Quantum_FPGA is
    Port (
        clk    : in std_logic;
        reset  : in std_logic;
        t      : in  cfixed;
        output : out cmatrix
    );
end Quantum_FPGA;

architecture Behavioral of Quantum_FPGA is

component Pade_Top_Level
    Port (
        clk    : in std_logic;
        reset  : in std_logic;
        t      : in  cfixed;
        output : out cmatrix
    );
end component;



begin
    

end Behavioral;
