library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Pade_Denominator is
    Port (
        B : in  cmatrixHigh;
        P : out cmatrixHigh
    );
end Pade_Denominator;

architecture Structural of Pade_Denominator is

    ----------------------------------------------------------------------------
    -- Component Declarations
    ----------------------------------------------------------------------------
    component Matrix_Plus_Scalar_High is
        port (
            input_cMatrixH : in  cmatrixHigh;
            scalar         : in  cfixedHigh;
            output_cMatrixH: out cmatrixHigh
        );
    end component;
    
    component Matrix_By_Matrix_Multiplication_High is
        port (
            A : in  cmatrixHigh;
            B : in  cmatrixHigh;
            C : out cmatrixHigh
        );
    end component;
    
    ----------------------------------------------------------------------------
    -- Constant Coefficient Declarations for Denominator (all imaginary parts are zero)
    ----------------------------------------------------------------------------
    constant coeff1 : cfixedHigh := ( re => to_sfixed(-90, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,    fixedHigh'high, fixedHigh'low) );
    constant coeff2 : cfixedHigh := ( re => to_sfixed(3960, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,    fixedHigh'high, fixedHigh'low) );
    constant coeff3 : cfixedHigh := ( re => to_sfixed(-110880, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,         fixedHigh'high, fixedHigh'low) );
    constant coeff4 : cfixedHigh := ( re => to_sfixed(2162160, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,         fixedHigh'high, fixedHigh'low) );
    constant coeff5 : cfixedHigh := ( re => to_sfixed(-30270240, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,          fixedHigh'high, fixedHigh'low) );
    constant coeff6 : cfixedHigh := ( re => to_sfixed(302702400, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,          fixedHigh'high, fixedHigh'low) );
    constant coeff7 : cfixedHigh := ( re => to_sfixed(-2075673600, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,           fixedHigh'high, fixedHigh'low) );
    constant coeff8 : cfixedHigh := ( re => to_sfixed(8821612800, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,           fixedHigh'high, fixedHigh'low) );
    constant coeff9 : cfixedHigh := ( re => to_sfixed(-17643225600, fixedHigh'high, fixedHigh'low),
                                      im => to_sfixed(0,            fixedHigh'high, fixedHigh'low) );
                                      
    ----------------------------------------------------------------------------
    -- Signal Declarations for Intermediate Results
    ----------------------------------------------------------------------------
    signal T0, T1, T2, T3, T4, T5, T6, T7, T8 : cmatrixHigh;
    signal M1, M2, M3, M4, M5, M6, M7, M8       : cmatrixHigh;

begin

    -- T0 = B + coeff1  (i.e. B - 90)
    U0: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => B,
            scalar         => coeff1,
            output_cMatrixH=> T0
        );
    
    -- M1 = T0 * B
    U1: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T0,
            B => B,
            C => M1
        );
    
    -- T1 = M1 + coeff2
    U2: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M1,
            scalar         => coeff2,
            output_cMatrixH=> T1
        );
    
    -- M2 = T1 * B
    U3: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T1,
            B => B,
            C => M2
        );
    
    -- T2 = M2 + coeff3
    U4: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M2,
            scalar         => coeff3,
            output_cMatrixH=> T2
        );
    
    -- M3 = T2 * B
    U5: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T2,
            B => B,
            C => M3
        );
    
    -- T3 = M3 + coeff4
    U6: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M3,
            scalar         => coeff4,
            output_cMatrixH=> T3
        );
    
    -- M4 = T3 * B
    U7: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T3,
            B => B,
            C => M4
        );
    
    -- T4 = M4 + coeff5
    U8: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M4,
            scalar         => coeff5,
            output_cMatrixH=> T4
        );
    
    -- M5 = T4 * B
    U9: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T4,
            B => B,
            C => M5
        );
    
    -- T5 = M5 + coeff6
    U10: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M5,
            scalar         => coeff6,
            output_cMatrixH=> T5
        );
    
    -- M6 = T5 * B
    U11: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T5,
            B => B,
            C => M6
        );
    
    -- T6 = M6 + coeff7
    U12: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M6,
            scalar         => coeff7,
            output_cMatrixH=> T6
        );
    
    -- M7 = T6 * B
    U13: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T6,
            B => B,
            C => M7
        );
    
    -- T7 = M7 + coeff8
    U14: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M7,
            scalar         => coeff8,
            output_cMatrixH=> T7
        );
    
    -- M8 = T7 * B
    U15: Matrix_By_Matrix_Multiplication_High
        port map (
            A => T7,
            B => B,
            C => M8
        );
    
    -- T8 = M8 + coeff9  --> Final result
    U16: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => M8,
            scalar         => coeff9,
            output_cMatrixH=> T8
        );
    
    -- Drive output
    P <= T8;

end Structural;
