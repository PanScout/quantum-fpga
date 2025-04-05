library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity Probability_Cvector is
    Port (
        cv_in   : in  cvector;  -- Input quantum state vector (complex amplitudes)
        prob_out: out cvector   -- Output vector with probabilities in the real part
    );
end Probability_Cvector;

architecture Behavioral of Probability_Cvector is
begin
    gen_prob: for i in 0 to dimension - 1 generate
        -- Compute probability = (re^2) + (im^2) and store it in the real part;
        -- Set the imaginary part to zero.
        prob_out(i).re <= resize(
                             resize(cv_in(i).re * cv_in(i).re, fixed64'high, fixed64'low) + 
                             resize(cv_in(i).im * cv_in(i).im, fixed64'high, fixed64'low),
                             fixed64'high, fixed64'low);
        
        prob_out(i).im <= (others => '0');
    end generate;
end Behavioral;
