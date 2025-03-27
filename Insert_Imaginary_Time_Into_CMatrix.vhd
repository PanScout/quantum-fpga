library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use work.fixed64.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity Insert_Imaginary_Time_Into_CMatrix is --H and i are hardcoded while time is an input
    Port (
        t : in  cfixed64;       -- Input scalar for second multiplication
	H : in cmatrix;
        C_out     : out cmatrix    -- Final output matrix in high precision
    );
end Insert_Imaginary_Time_Into_CMatrix;

architecture Structural of Insert_Imaginary_Time_Into_CMatrix is
    -- Hardcoded 4x4 matrix (values in lower precision)
    --constant FIXED_MATRIX : cmatrix := ( --Hamiltonian
        -- Row 0
        --(0 => (re => to_sfixed(1.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --1 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --2 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --3 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low))),
        
        -- Row 1
        --(0 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --1 => (re => to_sfixed(1.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --2 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --3 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low))),
        
        -- Row 2
        --(0 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --1 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --2 => (re => to_sfixed(1.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --3 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low))),
        
        -- Row 3
        --(0 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --1 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --2 => (re => to_sfixed(0.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)),
         --3 => (re => to_sfixed(1.0, fixed64'high, fixed64'low), im => to_sfixed(0.0, fixed64'high, fixed64'low)))
    --);

    -- First stage hard-coded scalar in lower precision
--    constant FIXED_SCALAR : cfixed64 := (
--        re => to_sfixed(2.0, fixed64'high, fixed64'low),
--       im => to_sfixed(1.0, fixed64'high, fixed64'low)
--   );

--    signal intermediate_matrix : cmatrix;  -- Result from the first multiplication
    signal final_low           : cmatrix;  -- Result from the second multiplication (low precision)
    signal t_imag : cfixed64;

    component Matrix_By_Scalar_Multiplication is
        Port (
            A      : in  cmatrix;
            scalar : in  cfixed64;
            C      : out cmatrix
        );
    end component;

begin

    t_imag <= (re => "0000000000000000000000000", im => t.re);

    -- First multiplication: Multiply fixed64 matrix by fixed64 scalar
    Mult1: Matrix_By_Scalar_Multiplication
        port map (
            A      => H,
            scalar => t_imag,
            C      => final_low
        );

    -- Second multiplication: Multiply intermediate matrix by input scalar
 --   Mult2: Matrix_By_Scalar_Multiplication
 --       port map (
 --           A      => intermediate_matrix,
 --           scalar => t_imag,
 --           C      => final_low
 --       );

    -- Convert the low-precision final result to high-precision using the conversion function
    C_out <= toCmatrixHigh(final_low);

end architecture Structural;

