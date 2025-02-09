library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;  -- Contains definitions for cmatrixHigh, cvectorHigh, and cfixedHigh

entity Adj_SubDetermiants is
  port(
    A      : in  cmatrixHigh;   -- 4×4 input matrix
    minors : out cvectorHigh    -- 4-element vector: determinants of the 3×3 minors
  );
end Adj_SubDetermiants;

architecture Behavioral of Adj_SubDetermiants is

    ----------------------------------------------------------------------------
    -- Local types for a 3-element vector and a 3×3 matrix of cfixedHigh.
    ----------------------------------------------------------------------------
    type cvector3 is array (0 to 2) of cfixedHigh;
    type cmatrix3 is array (0 to 2) of cvector3;

    ----------------------------------------------------------------------------
    -- Basic Complex Arithmetic Functions for cfixedHigh (internal resizing)
    ----------------------------------------------------------------------------

    -- Complex multiplication: (a + j*b)*(c + j*d) = (a*c - b*d) + j(a*d + b*c)
    function cmul(a, b : cfixedHigh) return cfixedHigh is
        variable result: cfixedHigh;
    begin
        result.re := resize(a.re * b.re - a.im * b.im, fixedHigh'high, fixedHigh'low);
        result.im := resize(a.re * b.im + a.im * b.re, fixedHigh'high, fixedHigh'low);
        return result;
    end function;

    -- Complex addition
    function cadd(a, b : cfixedHigh) return cfixedHigh is
        variable result: cfixedHigh;
    begin
        result.re := resize(a.re + b.re, fixedHigh'high, fixedHigh'low);
        result.im := resize(a.im + b.im, fixedHigh'high, fixedHigh'low);
        return result;
    end function;

    -- Complex subtraction
    function csub(a, b : cfixedHigh) return cfixedHigh is
        variable result: cfixedHigh;
    begin
        result.re := resize(a.re - b.re, fixedHigh'high, fixedHigh'low);
        result.im := resize(a.im - b.im, fixedHigh'high, fixedHigh'low);
        return result;
    end function;

    -- Constant zero value (may be useful in arithmetic)
    constant czero : cfixedHigh := (
        re => to_sfixed(0, fixedHigh'high, fixedHigh'low),
        im => to_sfixed(0, fixedHigh'high, fixedHigh'low)
    );

    ----------------------------------------------------------------------------
    -- Function: get_minor
    -- Given a 4×4 matrix A and an integer j (0 to 3), returns the 3×3 matrix 
    -- obtained by deleting row 0 and column j.
    ----------------------------------------------------------------------------
    function get_minor(A: cmatrixHigh; j: integer) return cmatrix3 is
        variable M: cmatrix3;
        variable col_index: integer;
    begin
        -- Loop over the rows of the minor (which correspond to original rows 1,2,3)
        for i in 0 to 2 loop
            -- Loop over the 3 columns of the minor
            for k in 0 to 2 loop
                if k < j then
                    col_index := k;
                else
                    col_index := k + 1;
                end if;
                M(i)(k) := A(i+1)(col_index);
            end loop;
        end loop;
        return M;
    end function;

    ----------------------------------------------------------------------------
    -- Function: det3x3
    -- Computes the determinant of a 3×3 matrix of cfixedHigh.
    -- For a matrix M with elements:
    --
    --   M = | m11  m12  m13 |
    --       | m21  m22  m23 |
    --       | m31  m32  m33 |
    --
    -- the determinant is:
    --
    --   det(M) = m11*(m22*m33 - m23*m32) - m12*(m21*m33 - m23*m31)
    --            + m13*(m21*m32 - m22*m31)
    ----------------------------------------------------------------------------
    function det3x3(M: cmatrix3) return cfixedHigh is
        variable term1, term2, term3: cfixedHigh;
    begin
        term1 := cmul(M(0)(0), csub(cmul(M(1)(1), M(2)(2)), cmul(M(1)(2), M(2)(1))));
        term2 := cmul(M(0)(1), csub(cmul(M(1)(0), M(2)(2)), cmul(M(1)(2), M(2)(0))));
        term3 := cmul(M(0)(2), csub(cmul(M(1)(0), M(2)(1)), cmul(M(1)(1), M(2)(0))));
        return cadd(csub(term1, term2), term3);
    end function;

    ----------------------------------------------------------------------------
    -- Function: compute_adj_minors
    -- Computes a vector (of length 4) whose j-th element is the signed 
    -- determinant of the 3×3 minor (obtained by deleting row 0 and column j)
    -- That is, result(j) = (-1)^(j) * det( get_minor(A, j) ).
    ----------------------------------------------------------------------------
    function compute_adj_minors(A: cmatrixHigh) return cvectorHigh is
        variable result: cvectorHigh;
        variable minor_mat: cmatrix3;
        variable det_val: cfixedHigh;
        variable sign: cfixedHigh;
    begin
        for j in 0 to 3 loop
            minor_mat := get_minor(A, j);
            det_val := det3x3(minor_mat);
            if (j mod 2 = 0) then
                sign.re := to_sfixed(1, fixedHigh'high, fixedHigh'low);
                sign.im := to_sfixed(0, fixedHigh'high, fixedHigh'low);
            else
                sign.re := to_sfixed(-1, fixedHigh'high, fixedHigh'low);
                sign.im := to_sfixed(0, fixedHigh'high, fixedHigh'low);
            end if;
            result(j) := cmul(sign, det_val);
        end loop;
        return result;
    end function;

begin
    -- Concurrently assign the output minors vector by computing the 3×3 determinants.
    minors <= compute_adj_minors(A);
end Behavioral;

