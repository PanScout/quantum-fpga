library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use work.fixed64.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity Insert_Imaginary_Time_Into_CMatrix is -- H and i are hardcoded while time is an input
    Port (
        t      : in  cfixed64;       -- Input scalar for second multiplication
        H      : in  cmatrix;
        C_out  : out cmatrix         -- Final output matrix in high precision
    );
end Insert_Imaginary_Time_Into_CMatrix;

architecture Structural of Insert_Imaginary_Time_Into_CMatrix is
    signal final_low : cmatrix;   -- Result from the multiplication (low precision)
    signal t_imag    : cfixed64;

    component Matrix_By_Scalar_Multiplication is
        Port (
            A      : in  cmatrix;
            scalar : in  cfixed64;
            C      : out cmatrix
        );
    end component;

begin

    t_imag <= (re => (others => '0'), im => t.re);

    -- First multiplication: Multiply fixed64 matrix by fixed64 scalar
    Mult1: Matrix_By_Scalar_Multiplication
        port map (
            A      => H,
            scalar => t_imag,
            C      => final_low
        );

    -- Final output assignment
    C_out <= final_low;

end architecture Structural;
