library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;  -- Use the package with your type declarations

entity Calculate_Matrix_Determinant is
    port(
        A   : in  cmatrixHigh;   -- 4x4 matrix (cmatrixHigh)
        det : out cfixedHigh     -- Determinant (complex high-precision value)
    );
end Calculate_Matrix_Determinant;

architecture Behavioral of Calculate_Matrix_Determinant is

    ----------------------------------------------------------------------------
    -- Complex Arithmetic Functions for cfixedHigh (internal resize only)
    ----------------------------------------------------------------------------

    -- Complex multiplication: (a + j*b) * (c + j*d) = (a*c - b*d) + j(a*d + b*c)
    function cmul(a, b : cfixedHigh) return cfixedHigh is
        variable result   : cfixedHigh;
        variable mult_re, mult_im : sfixed(fixedHigh'high downto fixedHigh'low);
    begin
        -- Compute real part: a.re * b.re - a.im * b.im
        mult_re := resize(resize(a.re * b.re, fixedHigh'high, fixedHigh'low) - resize(a.im * b.im, fixedHigh'high, fixedHigh'low), fixedHigh'high, fixedHigh'low);
        -- Compute imaginary part: a.re * b.im + a.im * b.re
        mult_im := resize(resize(a.re * b.im, fixedHigh'high, fixedHigh'low) + resize(a.im * b.re, fixedHigh'high, fixedHigh'low), fixedHigh'high, fixedHigh'low);
        result.re := resize(mult_re, fixedHigh'high, fixedHigh'low);
        result.im := resize(mult_im, fixedHigh'high, fixedHigh'low);
        return result;
    end function;

    -- Complex addition with internal resize
    function cadd(a, b : cfixedHigh) return cfixedHigh is
        variable result : cfixedHigh;
    begin
        result.re := resize(a.re + b.re, fixedHigh'high, fixedHigh'low);
        result.im := resize(a.im + b.im, fixedHigh'high, fixedHigh'low);
        return result;
    end function;

    -- Complex subtraction with internal resize
    function csub(a, b : cfixedHigh) return cfixedHigh is
        variable result : cfixedHigh;
    begin
        result.re := resize(a.re - b.re, fixedHigh'high, fixedHigh'low);
        result.im := resize(a.im - b.im, fixedHigh'high, fixedHigh'low);
        return result;
    end function;

    -- Constant zero value for cfixedHigh
    constant czero : cfixedHigh := (
        re => to_sfixed(0, fixedHigh'high, fixedHigh'low),
        im => to_sfixed(0, fixedHigh'high, fixedHigh'low)
    );

    ----------------------------------------------------------------------------
    -- Determinant Function for a 4x4 Matrix using arithmetic functions only
    ----------------------------------------------------------------------------
    function det4x4(A: cmatrixHigh) return cfixedHigh is
        variable term1,  term2,  term3,  term4  : cfixedHigh;
        variable term5,  term6,  term7,  term8  : cfixedHigh;
        variable term9,  term10, term11, term12 : cfixedHigh;
        variable term13, term14, term15, term16 : cfixedHigh;
        variable term17, term18, term19, term20 : cfixedHigh;
        variable term21, term22, term23, term24 : cfixedHigh;
        variable result : cfixedHigh := czero;
    begin
        term1  := cmul(cmul(cmul(A(0)(0), A(1)(1)), A(2)(2)), A(3)(3));  -- a11*a22*a33*a44
        term2  := cmul(cmul(cmul(A(0)(0), A(1)(1)), A(2)(3)), A(3)(2));  -- a11*a22*a34*a43
        term3  := cmul(cmul(cmul(A(0)(0), A(1)(2)), A(2)(1)), A(3)(3));  -- a11*a23*a32*a44
        term4  := cmul(cmul(cmul(A(0)(0), A(1)(2)), A(2)(3)), A(3)(1));  -- a11*a23*a34*a42
        term5  := cmul(cmul(cmul(A(0)(0), A(1)(3)), A(2)(1)), A(3)(2));  -- a11*a24*a32*a43
        term6  := cmul(cmul(cmul(A(0)(0), A(1)(3)), A(2)(2)), A(3)(1));  -- a11*a24*a33*a42
        term7  := cmul(cmul(cmul(A(0)(1), A(1)(0)), A(2)(2)), A(3)(3));  -- a12*a21*a33*a44
        term8  := cmul(cmul(cmul(A(0)(1), A(1)(0)), A(2)(3)), A(3)(2));  -- a12*a21*a34*a43
        term9  := cmul(cmul(cmul(A(0)(1), A(1)(2)), A(2)(0)), A(3)(3));  -- a12*a23*a31*a44
        term10 := cmul(cmul(cmul(A(0)(1), A(1)(2)), A(2)(3)), A(3)(0));  -- a12*a23*a34*a41
        term11 := cmul(cmul(cmul(A(0)(1), A(1)(3)), A(2)(0)), A(3)(2));  -- a12*a24*a31*a43
        term12 := cmul(cmul(cmul(A(0)(1), A(1)(3)), A(2)(2)), A(3)(0));  -- a12*a24*a33*a41
        term13 := cmul(cmul(cmul(A(0)(2), A(1)(0)), A(2)(1)), A(3)(3));  -- a13*a21*a32*a44
        term14 := cmul(cmul(cmul(A(0)(2), A(1)(0)), A(2)(3)), A(3)(1));  -- a13*a21*a34*a42
        term15 := cmul(cmul(cmul(A(0)(2), A(1)(1)), A(2)(0)), A(3)(3));  -- a13*a22*a31*a44
        term16 := cmul(cmul(cmul(A(0)(2), A(1)(1)), A(2)(3)), A(3)(0));  -- a13*a22*a34*a41
        term17 := cmul(cmul(cmul(A(0)(2), A(1)(3)), A(2)(0)), A(3)(1));  -- a13*a24*a31*a42
        term18 := cmul(cmul(cmul(A(0)(2), A(1)(3)), A(2)(1)), A(3)(0));  -- a13*a24*a32*a41
        term19 := cmul(cmul(cmul(A(0)(3), A(1)(0)), A(2)(1)), A(3)(2));  -- a14*a21*a32*a43
        term20 := cmul(cmul(cmul(A(0)(3), A(1)(0)), A(2)(2)), A(3)(1));  -- a14*a21*a33*a42
        term21 := cmul(cmul(cmul(A(0)(3), A(1)(1)), A(2)(0)), A(3)(2));  -- a14*a22*a31*a43
        term22 := cmul(cmul(cmul(A(0)(3), A(1)(1)), A(2)(2)), A(3)(0));  -- a14*a22*a33*a41
        term23 := cmul(cmul(cmul(A(0)(3), A(1)(2)), A(2)(0)), A(3)(1));  -- a14*a23*a31*a42
        term24 := cmul(cmul(cmul(A(0)(3), A(1)(2)), A(2)(1)), A(3)(0));  -- a14*a23*a32*a41

        result := csub(term1, term2);
        result := csub(result, term3);
        result := cadd(result, term4);
        result := cadd(result, term5);
        result := csub(result, term6);
        result := csub(result, term7);
        result := cadd(result, term8);
        result := cadd(result, term9);
        result := csub(result, term10);
        result := csub(result, term11);
        result := cadd(result, term12);
        result := cadd(result, term13);
        result := csub(result, term14);
        result := csub(result, term15);
        result := cadd(result, term16);
        result := cadd(result, term17);
        result := csub(result, term18);
        result := csub(result, term19);
        result := cadd(result, term20);
        result := cadd(result, term21);
        result := csub(result, term22);
        result := csub(result, term23);
        result := cadd(result, term24);

        return result;
    end function;

begin
    ----------------------------------------------------------------------------
    -- Concurrent Assignment: Calculate determinant without extra resize calls.
    ----------------------------------------------------------------------------
    det <= det4x4(A);
end Behavioral;

