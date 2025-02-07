library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Insert_Imaginary_Time_Into_CMatrix is
    Port (
        t : in  cfixed;       -- Input scalar for second multiplication
        C_out     : out cmatrixHigh    -- Final output matrix in high precision
    );
end Insert_Imaginary_Time_Into_CMatrix;

architecture Structural of Insert_Imaginary_Time_Into_CMatrix is
    -- Hardcoded 4x4 matrix (values in lower precision)
    constant FIXED_MATRIX : cmatrix := (
        -- Row 0
        (0 => (re => to_sfixed(1.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         1 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         2 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         3 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low))),
        
        -- Row 1
        (0 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         1 => (re => to_sfixed(1.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         2 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         3 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low))),
        
        -- Row 2
        (0 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         1 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         2 => (re => to_sfixed(1.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         3 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low))),
        
        -- Row 3
        (0 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         1 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         2 => (re => to_sfixed(0.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)),
         3 => (re => to_sfixed(1.0, fixed'high, fixed'low), im => to_sfixed(0.0, fixed'high, fixed'low)))
    );

    -- First stage hard-coded scalar in lower precision
    constant FIXED_SCALAR : cfixed := (
        re => to_sfixed(2.0, fixed'high, fixed'low),
        im => to_sfixed(1.0, fixed'high, fixed'low)
    );

    signal intermediate_matrix : cmatrix;  -- Result from the first multiplication
    signal final_low           : cmatrix;  -- Result from the second multiplication (low precision)

    component Matrix_By_Scalar_Multiplication is
        Port (
            A      : in  cmatrix;
            scalar : in  cfixed;
            C      : out cmatrix
        );
    end component;

begin
    -- First multiplication: Multiply fixed matrix by fixed scalar
    Mult1: Matrix_By_Scalar_Multiplication
        port map (
            A      => FIXED_MATRIX,
            scalar => FIXED_SCALAR,
            C      => intermediate_matrix
        );

    -- Second multiplication: Multiply intermediate matrix by input scalar
    Mult2: Matrix_By_Scalar_Multiplication
        port map (
            A      => intermediate_matrix,
            scalar => t,
            C      => final_low
        );

    -- Convert the low-precision final result to high-precision using the conversion function
    C_out <= toCmatrixHigh(final_low);

end architecture Structural;

