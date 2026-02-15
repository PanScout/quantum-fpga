library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Newtons_Guess is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        A        : in  cmatrix;
        scaled_AT : out cmatrix
    );
end Newtons_Guess;

architecture Structural of Newtons_Guess is
    component Matrix_Transpose is
        Port (
            input_matrix  : in  cmatrix;
            output_matrix : out cmatrix
        );
    end component;
    
    component Calculate_Norm_And_Compare is
        port (
            A              : in  cmatrix;
            InfinityNormOut : out cfixed64
        );
    end component;
    
    component ReciprocalEstimation is
        Port ( 
            x : in fixed64;   -- Input signal (64-bit)
            y : out fixed64   -- Output signal (64-bit)
        );
    end component;
    
    signal AT : cmatrix;
    signal infinity_norm, one_norm : cfixed64;
    signal norm_product : fixed64;
    signal reciprocal_norm : fixed64;
begin
    -- Stage 1: Transpose matrix and compute norms
    TRANSPOSE: Matrix_Transpose
    port map(A, AT);
    
    INF: Calculate_Norm_And_Compare port map(A, infinity_norm);
    ONE: Calculate_Norm_And_Compare port map(AT, one_norm);
    
    -- Compute N1 * N2 directly
    norm_product <= resize(
        infinity_norm.re * one_norm.re,
        fixed64'high,
        fixed64'low,
        fixed_overflow_style,
        fixed_round_style
    );
    
    -- Calculate reciprocal of norm_product using ReciprocalEstimation
    RECIPROCAL: ReciprocalEstimation
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
                        fixed64'high,
                        fixed64'low
                    );
                    scaled_AT(i)(j).im <= resize(
                        AT(i)(j).im * reciprocal_norm,
                        fixed64'high,
                        fixed64'low
                    );
                end if;
            end process;
        end generate;
    end generate;
end Structural;