library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.ALL;  -- Ensure cfixed is a record of std_logic_vector for re and im

entity Complex_ALU is
    Port (
        A       : in  cfixed;
        B       : in  cfixed;
        Op      : in  std_logic_vector(1 downto 0);
        Result  : out cfixed
    );
end Complex_ALU;

architecture Behavioral of Complex_ALU is

    signal div_denom : std_logic_vector(A.re'range);  -- Denominator for division

    -- Custom division function (placeholder for actual implementation)
    function divide(numerator, denominator : signed) return signed is
        -- Implement division logic here (this is a placeholder)
        variable result : signed(numerator'range) := (others => '0');
    begin
        -- Replace with actual division logic (e.g., restoring division)
        return result;
    end function;

begin

    -- Compute denominator: (B.re^2 + B.im^2)
    process(B)
        variable sq_re, sq_im : signed(2*A.re'length-1 downto 0);
        variable sum_sq : signed(2*A.re'length downto 0);
    begin
        sq_re := signed(B.re) * signed(B.re);
        sq_im := signed(B.im) * signed(B.im);
        sum_sq := resize(sq_re, sum_sq'length) + resize(sq_im, sum_sq'length);
        div_denom <= std_logic_vector(resize(sum_sq, A.re'length));
    end process;

    -- Real Part Operations
    process(A, B, Op, div_denom)
        variable temp_add, temp_sub, temp_mul_re, temp_mul_im, temp_div_num, temp_div_res : signed(A.re'range);
        variable temp_denom : signed(A.re'range);
    begin
        case Op is
            when "00" =>  -- ADD
                temp_add := resize(signed(A.re) + signed(B.re), A.re'length);
                Result.re <= std_logic_vector(temp_add);
            when "01" =>  -- SUB
                temp_sub := resize(signed(A.re) - signed(B.re), A.re'length);
                Result.re <= std_logic_vector(temp_sub);
            when "10" =>  -- MUL
                temp_mul_re := resize(signed(A.re) * signed(B.re) - signed(A.im) * signed(B.im), A.re'length);
                Result.re <= std_logic_vector(temp_mul_re);
            when "11" =>  -- DIV
                temp_div_num := resize(signed(A.re) * signed(B.re) + signed(A.im) * signed(B.im), A.re'length);
                temp_denom := signed(div_denom);
                temp_div_res := divide(temp_div_num, temp_denom);
                Result.re <= std_logic_vector(temp_div_res);
            when others =>
                Result.re <= (others => '0');
        end case;
    end process;

    -- Imaginary Part Operations
    process(A, B, Op, div_denom)
        variable temp_add, temp_sub, temp_mul_re_im, temp_mul_im_re, temp_div_num, temp_div_res : signed(A.im'range);
        variable temp_denom : signed(A.im'range);
    begin
        case Op is
            when "00" =>  -- ADD
                temp_add := resize(signed(A.im) + signed(B.im), A.im'length);
                Result.im <= std_logic_vector(temp_add);
            when "01" =>  -- SUB
                temp_sub := resize(signed(A.im) - signed(B.im), A.im'length);
                Result.im <= std_logic_vector(temp_sub);
            when "10" =>  -- MUL
                temp_mul_re_im := resize(signed(A.re) * signed(B.im) + signed(A.im) * signed(B.re), A.im'length);
                Result.im <= std_logic_vector(temp_mul_re_im);
            when "11" =>  -- DIV
                temp_div_num := resize(signed(A.im) * signed(B.re) - signed(A.re) * signed(B.im), A.im'length);
                temp_denom := signed(div_denom);
                temp_div_res := divide(temp_div_num, temp_denom);
                Result.im <= std_logic_vector(temp_div_res);
            when others =>
                Result.im <= (others => '0');
        end case;
    end process;

end Behavioral;