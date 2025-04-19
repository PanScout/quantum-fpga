library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Multiply_Column_By_Scalar is
    Port (
        constComplex : in  cfixed64;   -- High‑precision complex scalar
        rowVector    : in  cvector;     -- High‑precision input vector
        outputVector : out cvector      -- High‑precision output vector
    );
end Multiply_Column_By_Scalar;

architecture Minimal of Multiply_Column_By_Scalar is
    -- your fixed64 range is 36 bits wide (high downto low)
    constant OUT_HIGH : integer := fixed64'high;
    constant OUT_LOW  : integer := fixed64'low;

    -- 1‑time scalar sum, explicitly truncated to 36 bits
    signal a_sum : sfixed(OUT_HIGH downto OUT_LOW);
begin
    a_sum <= resize(constComplex.re + constComplex.im,
                    OUT_HIGH, OUT_LOW);

    gen_multiply: for i in 0 to dimension-1 generate
        -- per‑element 36‑bit intermediates
        signal b_sum           : sfixed(OUT_HIGH downto OUT_LOW);
        signal p1_s, p2_s, p3_s : sfixed(OUT_HIGH downto OUT_LOW);
    begin
        -- a) two direct multiplies, each truncated to 36 bits
        p1_s <= resize(constComplex.re * rowVector(i).re,
                       OUT_HIGH, OUT_LOW);
        p2_s <= resize(constComplex.im * rowVector(i).im,
                       OUT_HIGH, OUT_LOW);

        -- b) per‑element vector sum (36+36→37), then truncate → 36
        b_sum <= resize(
                    rowVector(i).re + rowVector(i).im,
                    OUT_HIGH, OUT_LOW
                 );

        -- c) Gauss cross‑term multiply (36×36→72), then truncate → 36
        p3_s <= resize(
                    a_sum * b_sum,
                    OUT_HIGH, OUT_LOW
               );

        -- d) real = p1_s – p2_s  (36–36→37), truncate to 36
        outputVector(i).re <= resize(
                                p1_s - p2_s,
                                OUT_HIGH, OUT_LOW
                             );

        -- e) imag = p3_s – p1_s – p2_s  (36–36–36→38), truncate to 36
        outputVector(i).im <= resize(
                                p3_s - p1_s - p2_s,
                                OUT_HIGH, OUT_LOW
                             );
    end generate gen_multiply;

end architecture Minimal;
