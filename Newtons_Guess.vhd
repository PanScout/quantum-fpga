library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Newtons_Guess is
    Port (
        A          : in  cmatrixHigh;
        scaled_AT  : out cmatrixHigh
    );
end Newtons_Guess;

architecture Structural of Newtons_Guess is
    component Matrix_Transpose is
        Port (
            input_matrix  : in  cmatrixHigh;
            output_matrix : out cmatrixHigh
        );
    end component;

    component Calculate_Norm_And_Compare is
        port (
            A              : in  cmatrixHigh;
            isBelow        : out std_logic;
            InfinityNormOut : out cfixedHigh
        );
    end component;

    constant SCALE_FACTOR : integer := 24;  -- Must be <=24 for Q13.50 format
    constant SCALE_MUL    : sfixed(13 downto -50) := 
        to_sfixed(2.0**SCALE_FACTOR, 13, -50);
    constant EPSILON : fixedHigh := b"0000000000000000000000000000000000000000000000000000010001100110";

    signal AT : cmatrixHigh;
    signal infinity_norm, one_norm : cfixedHigh;
    signal scaled_norm_product, reciprocal_product : sfixed(13 downto -50);
    
begin
    TRANSPOSE: Matrix_Transpose
    port map(A, AT);

    INF: Calculate_Norm_And_Compare port map(A, open, infinity_norm);
    ONE: Calculate_Norm_And_Compare port map(AT, open, one_norm);

    -- Stage 1: Scale and multiply norms (keeps within 64 bits)
    scaled_norm_product <= resize(
        (infinity_norm.re / SCALE_MUL) * (one_norm.re / SCALE_MUL),
        scaled_norm_product'high,
        scaled_norm_product'low
    );

    -- Stage 2: Calculate reciprocal with overflow protection
    reciprocal_process: process(scaled_norm_product)
    begin
        if scaled_norm_product < EPSILON then
            reciprocal_product <= (others => '0');
        else
            reciprocal_product <= resize(
                reciprocal(scaled_norm_product),
                13,
                -50
            );
        end if;
    end process;

    -- Stage 3: Apply scaling with exact mathematical equivalence
    gen_scaling: for i in 0 to numBasisStates-1 generate
        gen_scaling_row: for j in 0 to numBasisStates-1 generate
            -- Original formula: AT/(N1*N2) 
            -- New equivalent: (AT * reciprocal_product) / (SCALE_MUL^2)
            scaled_AT(i)(j).re <= resize(
                (AT(i)(j).re * reciprocal_product) / SCALE_MUL / SCALE_MUL,
                fixedHigh'high,
                fixedHigh'low
            );
            scaled_AT(i)(j).im <= resize(
                (AT(i)(j).im * reciprocal_product) / SCALE_MUL / SCALE_MUL,
                fixedHigh'high,
                fixedHigh'low
            );
        end generate;
    end generate;
end Structural;
