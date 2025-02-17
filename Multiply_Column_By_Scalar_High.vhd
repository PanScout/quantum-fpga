library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL; 

library work;
use work.qTypes.ALL;  -- Import the qTypes package

entity Multiply_Column_By_Scalar_High is
    Port (
        constComplex  : in  cfixedHigh;               -- Combined constant complex input
        rowVector  : in  cvectorHigh;              -- Input vector of complex numbers
        outputVector  : out cvectorHigh              -- Output vector of complex numbers
    );
end Multiply_Column_By_Scalar_High;

architecture Behavioral of Multiply_Column_By_Scalar_High is

    -- Component Declaration for Complex_ALU using qTypes
    component Complex_ALU_High
        Port (
            A      : in  cfixedHigh;
            B      : in  cfixedHigh;
            Op     : in  std_logic_vector(1 downto 0);  -- 2-bit operation code
            Result : out cfixedHigh
        );
    end component;

begin

    -- Generate Loop for Multiplying each element in the columnVector with constComplex
    gen_multiply: for i in 0 to numBasisStates - 1 generate
        C_ALU_inst: Complex_ALU_High
            port map (
                A      => constComplex,
                B      => rowVector(i),
                Op     => "10",                       -- Operation code for multiplication
                Result => outputVector(i)
            );
    end generate gen_multiply;

end Behavioral;
