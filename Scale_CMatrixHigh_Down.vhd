library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Scale_CMatrixHigh_Down is
port (
    Input_Matrix  : in  cmatrixHigh;
    Shift_Amount  : in  fixedHigh; -- Interpreted as signed shift value
    Output_Matrix : out cmatrixHigh
);
end Scale_CMatrixHigh_Down;

architecture Structural of Scale_CMatrixHigh_Down is
    -- Constants derived from fixedHigh definition
    constant MAX_LEFT_SHIFT  : integer := 40; -- Matches fixedHigh integer bits
    constant MAX_RIGHT_SHIFT : integer := 64; -- Matches fixedHigh fractional bits

    -- Extract sign bit (MSB of fixedHigh)
    signal shift_sign : std_logic := Shift_Amount(Shift_Amount'high);
    
    -- Magnitude of shift (absolute value, treated as unsigned)
    signal shift_mag  : ufixed(MAX_LEFT_SHIFT-1 downto 0) := 
        to_ufixed(abs(Shift_Amount), MAX_LEFT_SHIFT-1, 0);
begin
    process(Input_Matrix, Shift_Amount)
    begin
        -- Apply shifts to all matrix elements combinatorially
        for i in 0 to numBasisStates-1 loop
            for j in 0 to numBasisStates-1 loop
                -- Real component
                if shift_sign = '0' then
                    Output_Matrix(i)(j).re <= 
                        shift_left(Input_Matrix(i)(j).re, to_integer(shift_mag));
                else
                    Output_Matrix(i)(j).re <= 
                        shift_right(Input_Matrix(i)(j).re, to_integer(shift_mag));
                end if;
                
                -- Imaginary component
                if shift_sign = '0' then
                    Output_Matrix(i)(j).im <= 
                        shift_left(Input_Matrix(i)(j).im, to_integer(shift_mag));
                else
                    Output_Matrix(i)(j).im <= 
                        shift_right(Input_Matrix(i)(j).im, to_integer(shift_mag));
                end if;
            end loop;
        end loop;
    end process;
end Structural;