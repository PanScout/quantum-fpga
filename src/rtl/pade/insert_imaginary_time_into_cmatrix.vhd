library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use work.sfixed36.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity insert_imaginary_time_into_cmatrix is -- H and i are hardcoded while time is an input
    Port (
        t      : in  csfixed36;       -- Input scalar for second multiplication
        H      : in  cmatrix;
        C_out  : out cmatrix         -- Final output matrix in high precision
    );
end insert_imaginary_time_into_cmatrix;

architecture Structural of insert_imaginary_time_into_cmatrix is
    signal final_low : cmatrix;   -- Result from the multiplication (low precision)
    signal t_imag    : csfixed36;

    component matrix_by_scalar_multiplication is
        Port (
            A      : in  cmatrix;
            scalar : in  csfixed36;
            C      : out cmatrix
        );
    end component;

begin

    t_imag <= (re => (others => '0'), im => t.re);

    -- First multiplication: Multiply sfixed36 matrix by sfixed36 scalar
    Mult1: matrix_by_scalar_multiplication
        port map (
            A      => H,
            scalar => t_imag,
            C      => final_low
        );

    -- Final output assignment
    C_out <= final_low;

end architecture Structural;
