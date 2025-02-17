library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

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

    -- Internal signals
    signal AT : cmatrixHigh;
    signal infinity_norm_A, one_norm_A : cfixedHigh;
    --signal norm_product : sfixed(fixedHigh'high*2+1 downto fixedHigh'low*2);
    signal norm_product : signed(127 downto 0); 
    
begin
    -- Stage 1: Transpose the matrix
    TRANSPOSE: Matrix_Transpose
    port map(
        input_matrix => A,
        output_matrix => AT
    );

    -- Stage 2: Calculate norms
    INF_NORM_A: Calculate_Norm_And_Compare
    port map(
        A => A,
        InfinityNormOut => infinity_norm_A
    );

    ONE_NORM: Calculate_Norm_And_Compare
    port map(
        A => AT,  -- Infinity norm of transpose = 1-norm of original
        InfinityNormOut => one_norm_A
    );

    -- Stage 3: Calculate product of norms
    --norm_product <= infinity_norm_A.re * one_norm_A.re;
    norm_product <= signed(infinity_norm_A.re) * signed(one_norm_A.re);

    -- Stage 4: Scale transposed matrix
    gen_scaling: for i in 0 to numBasisStates-1 generate
        gen_scaling_row: for j in 0 to numBasisStates-1 generate
            --scaled_AT(i)(j).re <= resize(AT(i)(j).re / norm_product, fixedHigh'high, fixedHigh'low);
            --scaled_AT(i)(j).im <= resize(AT(i)(j).im / norm_product, fixedHigh'high, fixedHigh'low);
            signal real_scaled, imag_scaled : signed(63 downto 0);
        begin
            -- Compute scaled values manually (shift-based division)
            real_scaled <= signed(AT(i)(j).re) srl 6; -- Approximate division by norm_product
            imag_scaled <= signed(AT(i)(j).im) srl 6;

            -- Assign scaled values back to the output matrix
            scaled_AT(i)(j).re <= std_logic_vector(real_scaled);
            scaled_AT(i)(j).im <= std_logic_vector(imag_scaled);
        end generate gen_scaling_row;
    end generate gen_scaling;

end Structural;
