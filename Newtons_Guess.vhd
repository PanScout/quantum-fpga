library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Newtons_Guess is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        A        : in  cmatrixHigh;
        scaled_AT : out cmatrixHigh
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
            InfinityNormOut : out cfixedHigh
        );
    end component;

    component NewtonRaphsonReciprocal is
        Port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            start  : in  std_logic;
            X      : in  fixedHigh;
            Y      : out fixedHigh;
            done   : out std_logic
        );
    end component;

    signal AT : cmatrixHigh;
    signal infinity_norm, one_norm : cfixedHigh;
    signal norm_product : fixedHigh;
    signal recip_start, recip_done : std_logic := '0';
    signal reciprocal_norm : fixedHigh;

begin
    -- Stage 1: Transpose matrix and compute norms
    TRANSPOSE: Matrix_Transpose
    port map(A, AT);

    INF: Calculate_Norm_And_Compare port map(A, infinity_norm);
    ONE: Calculate_Norm_And_Compare port map(AT, one_norm);

    -- Compute N1 * N2 directly
    norm_product <= resize(
        infinity_norm.re * one_norm.re,
        fixedHigh'high,
        fixedHigh'low,
        fixed_overflow_style,
        fixed_round_style
    );

    -- Stage 2: Trigger Newton-Raphson unconditionally
    process(clk)
    begin
        if rising_edge(clk) then
            recip_start <= '1';  -- Always start (no epsilon check)
        end if;
    end process;

    -- Instantiate Newton-Raphson (20 iterations)
    NR_INST: NewtonRaphsonReciprocal
    port map (
        clk    => clk,
        reset  => reset,
        start  => recip_start,
        X      => norm_product,
        Y      => reciprocal_norm,
        done   => recip_done
    );

    -- Stage 3: Compute A^T / (N1*N2)
    gen_scaling: for i in 0 to numBasisStates-1 generate
        gen_scaling_row: for j in 0 to numBasisStates-1 generate
            process(clk)
            begin
                if rising_edge(clk) then
                    if recip_done = '1' then
                        scaled_AT(i)(j).re <= resize(
                            AT(i)(j).re * reciprocal_norm,
                            fixedHigh'high,
                            fixedHigh'low
                        );
                        scaled_AT(i)(j).im <= resize(
                            AT(i)(j).im * reciprocal_norm,
                            fixedHigh'high,
                            fixedHigh'low
                        );
                    end if;
                end if;
            end process;
        end generate;
    end generate;
end Structural;