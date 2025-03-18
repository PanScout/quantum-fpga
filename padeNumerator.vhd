library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL;
use work.qTypes.ALL;
use IEEE.fixed_pkg.ALL;

entity padeNumerator is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        B     : in  cmatrixHigh;
        P     : out cmatrixHigh;
        done  : out std_logic
    );
end padeNumerator;

architecture Behavioral of padeNumerator is

    component Matrix_Plus_Scalar_High is
        port (
            input_cMatrixH : in  cmatrixHigh;
            scalar         : in  cfixedHigh;
            output_cMatrixH: out cmatrixHigh
        );
    end component;

    component Matrix_By_Matrix_Multiplication_High is
        port (
            A : in  cmatrixHigh;
            B : in  cmatrixHigh;
            C : out cmatrixHigh
        );
    end component;

    -- Coefficient constants
    constant coeff1 : cfixedHigh := ( re => "0000000000000000000000000000000000000000000010110100000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff2 : cfixedHigh := ( re => "0000000000000000000000000000000000000001111011110000000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff3 : cfixedHigh := ( re => "0000000000000000000000000000000000110110001001000000000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff4 : cfixedHigh := ( re => "0000000000000000000000000000010000011111101111100000000000000000000000000000000000000000000000000000000000000000000",
				      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff5 : cfixedHigh := ( re => "0000000000000000000000000011100110111100011001000000000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff6 : cfixedHigh := ( re => "0000000000000000000000100100000101011011111010000000000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff7 : cfixedHigh := ( re => "0000000000000000000011110111011100001000100000000000000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff8 : cfixedHigh := ( re => "0000000000000000010000011011100111100100001000000000000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
    constant coeff9 : cfixedHigh := ( re => "0000000000000000100000110111001111001000010000000000000000000000000000000000000000000000000000000000000000000000000",
                                      im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
                                      
    type state_type is (IDLE, COMPUTING);
    signal state : state_type := IDLE;
    signal current_result, B_reg : cmatrixHigh;
    signal step_counter : integer range 0 to 17 := 0;
    signal current_coeff : cfixedHigh;
    signal adder_out, mult_out : cmatrixHigh;
    signal done_s : std_logic;  -- Internal signal for done

    -- Function to create a cmatrixHigh with all elements set to zero
    function init_cmatrixHigh_zero return cmatrixHigh is
        variable matrix : cmatrixHigh;
    begin
        for i in matrix'range loop
            for j in matrix(i)'range loop
                matrix(i)(j) := (
                    re => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
                    im =>  "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                );
            end loop;
        end loop;
        return matrix;
    end function;

begin

    ADDER: Matrix_Plus_Scalar_High
        port map (
            input_cMatrixH => current_result,
            scalar         => current_coeff,
            output_cMatrixH=> adder_out
        );

    MULTIPLIER: Matrix_By_Matrix_Multiplication_High
        port map (
            A => current_result,
            B => B_reg,
            C => mult_out
        );

    process(step_counter)
    begin
        case step_counter/2 is
            when 0 => current_coeff <= coeff1;
            when 1 => current_coeff <= coeff2;
            when 2 => current_coeff <= coeff3;
            when 3 => current_coeff <= coeff4;
            when 4 => current_coeff <= coeff5;
            when 5 => current_coeff <= coeff6;
            when 6 => current_coeff <= coeff7;
            when 7 => current_coeff <= coeff8;
            when 8 => current_coeff <= coeff9;
            when others =>
                current_coeff <= (
                    re => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
                    im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                );
        end case;
    end process;

    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            current_result <= init_cmatrixHigh_zero;
            B_reg <= init_cmatrixHigh_zero;
            step_counter <= 0;
            done_s <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    done_s <= '0';
                    if start = '1' then
                        B_reg <= B;
                        current_result <= B;
                        state <= COMPUTING;
                        step_counter <= 0;
                    end if;
                when COMPUTING =>
                    if step_counter < 17 then
                        if step_counter mod 2 = 0 then
                            current_result <= adder_out;
                        else
                            current_result <= mult_out;
                        end if;
                        step_counter <= step_counter + 1;
                    else
                        state <= IDLE;
                        done_s <= '1';
                    end if;
            end case;
        end if;
    end process;

    done <= done_s;

    P <= current_result when (state = IDLE and done_s = '1') else
         init_cmatrixHigh_zero;



end Behavioral;
