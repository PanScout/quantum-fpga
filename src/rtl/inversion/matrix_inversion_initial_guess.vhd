library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity matrix_inversion_initial_guess is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        A        : in  cmatrix;
        scaled_AT : out cmatrix
    );
end matrix_inversion_initial_guess;

architecture Structural of matrix_inversion_initial_guess is
    component matrix_transpose is
        Port (
            input_matrix  : in  cmatrix;
            output_matrix : out cmatrix
        );
    end component;
    
    component calculate_norm_and_compare is
        port (
            A              : in  cmatrix;
            InfinityNormOut : out csfixed36
        );
    end component;
    
    component linear_reciprocal_approximation is
        Port ( 
            x : in sfixed36;   -- Input signal (64-bit)
            y : out sfixed36   -- Output signal (64-bit)
        );
    end component;
    
    signal AT : cmatrix;
    signal infinity_norm, one_norm : csfixed36;
    signal norm_product : sfixed36;
    signal reciprocal_norm : sfixed36;
begin
    -- Stage 1: Transpose matrix and compute norms
    TRANSPOSE: matrix_transpose
    port map(A, AT);
    
    INF: calculate_norm_and_compare port map(A, infinity_norm);
    ONE: calculate_norm_and_compare port map(AT, one_norm);
    
    -- Compute N1 * N2 directly
    norm_product <= resize(
        infinity_norm.re * one_norm.re,
        sfixed36'high,
        sfixed36'low,
        fixed_overflow_style,
        fixed_round_style
    );
    
    -- Calculate reciprocal of norm_product using linear_reciprocal_approximation
    RECIPROCAL: linear_reciprocal_approximation
    port map(
        x => norm_product,
        y => reciprocal_norm
    );
    
    -- Stage 2: Compute A^T * (1/(N1*N2)) using registered reciprocal
    gen_scaling: for i in 0 to dimension-1 generate
        gen_scaling_row: for j in 0 to dimension-1 generate
            process(clk)
            begin
                if rising_edge(clk) then
                    scaled_AT(i)(j).re <= resize(
                        AT(i)(j).re * reciprocal_norm,
                        sfixed36'high,
                        sfixed36'low
                    );
                    scaled_AT(i)(j).im <= resize(
                        AT(i)(j).im * reciprocal_norm,
                        sfixed36'high,
                        sfixed36'low
                    );
                end if;
            end process;
        end generate;
    end generate;
end Structural;