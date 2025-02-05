library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL; 

library work;
use work.qTypes.ALL;  -- Import the qTypes package

entity multiplyColumnByScalar is
    Port (
        constComplex  : in  cfixed;               -- Combined constant complex input
        rowVector  : in  cvector;              -- Input vector of complex numbers
        outputVector  : out cvector              -- Output vector of complex numbers
    );
end multiplyColumnByScalar;

architecture Behavioral of multiplyColumnByScalar is

    -- Component Declaration for C_ALU using qTypes
    component C_ALU
        Port (
            A      : in  cfixed;
            B      : in  cfixed;
            Op     : in  std_logic_vector(1 downto 0);  -- 2-bit operation code
            Result : out cfixed
        );
    end component;

begin

    -- Generate Loop for Multiplying each element in the columnVector with constComplex
    gen_multiply: for i in 0 to numBasisStates - 1 generate
        C_ALU_inst: C_ALU
            port map (
                A      => constComplex,
                B      => rowVector(i),
                Op     => "10",                       -- Operation code for multiplication
                Result => outputVector(i)
            );
    end generate gen_multiply;

end Behavioral;
