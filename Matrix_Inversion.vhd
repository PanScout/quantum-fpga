library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Matrix_Inversion is
    Port (
        input_matrix  : in  cmatrixHigh;
        output_matrix : out cmatrixHigh
    );
end Matrix_Inversion;

architecture Behavioral of Matrix_Inversion is

    -- Define a wider type for intermediate arithmetic.
    subtype wide_mult is sfixed(45 downto -48);

    -- Local signals for matrix elements (of type cfixedHigh)
    signal a00, a01, a02, a03 : cfixedHigh;
    signal a10, a11, a12, a13 : cfixedHigh;
    signal a20, a21, a22, a23 : cfixedHigh;
    signal a30, a31, a32, a33 : cfixedHigh;

    -- Signals for cofactors
    signal cof00, cof01, cof02, cof03 : cfixedHigh;
    -- (cof10 through cof33 are similarly declared)
    signal cof10, cof11, cof12, cof13 : cfixedHigh;
    signal cof20, cof21, cof22, cof23 : cfixedHigh;
    signal cof30, cof31, cof32, cof33 : cfixedHigh;

    -- Signal for the overall determinant
    signal det : cfixedHigh;

begin

    -- Map the input matrix elements using double indexing.
    a00 <= input_matrix(0)(0);
    a01 <= input_matrix(0)(1);
    a02 <= input_matrix(0)(2);
    a03 <= input_matrix(0)(3);

    a10 <= input_matrix(1)(0);
    a11 <= input_matrix(1)(1);
    a12 <= input_matrix(1)(2);
    a13 <= input_matrix(1)(3);

    a20 <= input_matrix(2)(0);
    a21 <= input_matrix(2)(1);
    a22 <= input_matrix(2)(2);
    a23 <= input_matrix(2)(3);

    a30 <= input_matrix(3)(0);
    a31 <= input_matrix(3)(1);
    a32 <= input_matrix(3)(2);
    a33 <= input_matrix(3)(3);

    ----------------------------------------------------------------------------
    -- Compute cof00 (first cofactor) using the wide_mult type.
    ----------------------------------------------------------------------------
    cof00 <= resize(
              ( resize(a11, wide_mult'high, wide_mult'low) *
                ( resize(a22 * a33, wide_mult'high, wide_mult'low)
                  - resize(a23 * a32, wide_mult'high, wide_mult'low) )
              )
              -
              ( resize(a12, wide_mult'high, wide_mult'low) *
                ( resize(a21 * a33, wide_mult'high, wide_mult'low)
                  - resize(a23 * a31, wide_mult'high, wide_mult'low) )
              )
              +
              ( resize(a13, wide_mult'high, wide_mult'low) *
                ( resize(a21 * a32, wide_mult'high, wide_mult'low)
                  - resize(a22 * a31, wide_mult'high, wide_mult'low) )
              ),
              cfixedHigh'high, cfixedHigh'low);

    -- Similar explicit resizing must be applied for cof01 through cof33.
    -- (Below is cof01 as an example.)
    cof01 <= resize(
              -(
                ( resize(a10, wide_mult'high, wide_mult'low) *
                  ( resize(a22 * a33, wide_mult'high, wide_mult'low)
                    - resize(a23 * a32, wide_mult'high, wide_mult'low) )
                )
                -
                ( resize(a12, wide_mult'high, wide_mult'low) *
                  ( resize(a20 * a33, wide_mult'high, wide_mult'low)
                    - resize(a23 * a30, wide_mult'high, wide_mult'low) )
                )
                +
                ( resize(a13, wide_mult'high, wide_mult'low) *
                  ( resize(a20 * a32, wide_mult'high, wide_mult'low)
                    - resize(a22 * a30, wide_mult'high, wide_mult'low) )
                )
              ),
              cfixedHigh'high, cfixedHigh'low);

    -- (Implement cof02 ... cof33 similarly.)

    ----------------------------------------------------------------------------
    -- Compute the determinant by expanding along the first row.
    ----------------------------------------------------------------------------
    det <= resize(
            resize(a00, cfixedHigh'high, cfixedHigh'low) * cof00 +
            resize(a01, cfixedHigh'high, cfixedHigh'low) * cof01 +
            resize(a02, cfixedHigh'high, cfixedHigh'low) * cof02 +
            resize(a03, cfixedHigh'high, cfixedHigh'low) * cof03,
            cfixedHigh'high, cfixedHigh'low);

    ----------------------------------------------------------------------------
    -- Form the inverse matrix (adjugate divided by determinant).
    ----------------------------------------------------------------------------
    output_matrix(0)(0) <= cof00 / det;
    output_matrix(0)(1) <= cof10 / det;
    output_matrix(0)(2) <= cof20 / det;
    output_matrix(0)(3) <= cof30 / det;

    output_matrix(1)(0) <= cof01 / det;
    output_matrix(1)(1) <= cof11 / det;
    output_matrix(1)(2) <= cof21 / det;
    output_matrix(1)(3) <= cof31 / det;

    output_matrix(2)(0) <= cof02 / det;
    output_matrix(2)(1) <= cof12 / det;
    output_matrix(2)(2) <= cof22 / det;
    output_matrix(2)(3) <= cof32 / det;

    output_matrix(3)(0) <= cof03 / det;
    output_matrix(3)(1) <= cof13 / det;
    output_matrix(3)(2) <= cof23 / det;
    output_matrix(3)(3) <= cof33 / det;

end Behavioral;

