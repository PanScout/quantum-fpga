library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Matrix_By_Scalar_Multiplication is
    Port (
        A      : in  cmatrix;    -- Input matrix
        scalar : in  cfixed64;   -- Scalar to multiply
        C      : out cmatrix     -- Output matrix (A * scalar)
    );
end Matrix_By_Scalar_Multiplication;

architecture Minimal of Matrix_By_Scalar_Multiplication is
    -- final, 36‑bit fixed‑point width
    constant OUT_HIGH : integer := fixed64'high;
    constant OUT_LOW  : integer := fixed64'low;

    -- compute (scalar.re + scalar.im) once, then truncate
    signal a_sum : sfixed(OUT_HIGH downto OUT_LOW);
begin
    a_sum <= resize(scalar.re + scalar.im,
                    OUT_HIGH, OUT_LOW);

    gen_row : for row_idx in 0 to dimension-1 generate
        gen_col : for col_idx in 0 to dimension-1 generate
            -- all intermediates at 36‑bit width
            signal b_sum           : sfixed(OUT_HIGH downto OUT_LOW);
            signal p1_s, p2_s, p3_s : sfixed(OUT_HIGH downto OUT_LOW);
        begin
            -- 1) p1 = A.re * scalar.re, truncated to 36 bits
            p1_s <= resize(
                        A(row_idx)(col_idx).re * scalar.re,
                        OUT_HIGH, OUT_LOW
                    );

            -- 2) p2 = A.im * scalar.im, truncated to 36 bits
            p2_s <= resize(
                        A(row_idx)(col_idx).im * scalar.im,
                        OUT_HIGH, OUT_LOW
                    );

            -- 3) b_sum = A.re + A.im, truncated to 36 bits
            b_sum <= resize(
                        A(row_idx)(col_idx).re +
                        A(row_idx)(col_idx).im,
                        OUT_HIGH, OUT_LOW
                     );

            -- 4) p3 = (scalar.re+scalar.im)*b_sum, truncated
            p3_s <= resize(
                        a_sum * b_sum,
                        OUT_HIGH, OUT_LOW
                    );

            -- 5) final real = p1_s - p2_s, truncated
            C(row_idx)(col_idx).re <= resize(
                p1_s - p2_s,
                OUT_HIGH, OUT_LOW
            );

            -- 6) final imag = p3_s - p1_s - p2_s, truncated
            C(row_idx)(col_idx).im <= resize(
                p3_s - p1_s - p2_s,
                OUT_HIGH, OUT_LOW
            );
        end generate gen_col;
    end generate gen_row;
end architecture Minimal;
