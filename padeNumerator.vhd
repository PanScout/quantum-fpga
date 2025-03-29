library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

entity padeNumerator is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        B     : in  cmatrix;
        P     : out cmatrix;
        done  : out std_logic
    );
end padeNumerator;

architecture Behavioral of padeNumerator is

    component Matrix_Plus_Scalar is
        port (
            input_cMatrixH : in  cmatrix;
            scalar         : in  cfixed64;
            output_cMatrixH: out cmatrix
        );
    end component;

    component Matrix_By_Matrix_Multiplication is
        port (
            A : in  cmatrix;
            B : in  cmatrix;
            C : out cmatrix
        );
    end component;

    -- Horner's method coefficients for -(((B+12)B+60)B+120)
    constant COEFF1 : cfixed64 := (  -- +12
        re => "000000000001100000000000000000000000",
        im => to_sfixed(0, fixed64'high, fixed64'low)
    );
    constant COEFF2 : cfixed64 := (  -- +60
        re => "000000000111100000000000000000000000",
        im => to_sfixed(0, fixed64'high, fixed64'low)
    );
    constant COEFF3 : cfixed64 := (  -- +120
        re => "000000001111000000000000000000000000",
        im => to_sfixed(0, fixed64'high, fixed64'low)
    );

    type state_type is (IDLE, COMPUTING);
    signal state : state_type := IDLE;
    signal current_result, B_reg : cmatrix;
    signal step_counter : integer range 0 to 5 := 0;
    signal current_coeff : cfixed64;
    signal adder_out, mult_out : cmatrix;
    signal done_s : std_logic;

    function init_cmatrixHigh_zero return cmatrix is
        variable matrix : cmatrix;
    begin
        for i in matrix'range loop
            for j in matrix(i)'range loop
                matrix(i)(j) := (
                    re => to_sfixed(0, fixed64'high, fixed64'low),
                    im => to_sfixed(0, fixed64'high, fixed64'low)
                );
            end loop;
        end loop;
        return matrix;
    end function;

    -- Function to negate a cmatrix
    function negate_cmatrixHigh(matrix : cmatrix) return cmatrix is
        variable res : cmatrix;
    begin
        for i in matrix'range loop
            for j in matrix(i)'range loop
                res(i)(j).re := resize(-matrix(i)(j).re, fixed64'high, fixed64'low);
                res(i)(j).im := resize(-matrix(i)(j).im, fixed64'high, fixed64'low);
            end loop;
        end loop;
        return res;
    end function;

begin

    ADDER: Matrix_Plus_Scalar
        port map (
            input_cMatrixH => current_result,
            scalar         => current_coeff,
            output_cMatrixH=> adder_out
        );

    MULTIPLIER: Matrix_By_Matrix_Multiplication
        port map (
            A => current_result,
            B => B_reg,
            C => mult_out
        );

    process(step_counter)
    begin
        case step_counter/2 is  -- Coefficient selection logic
            when 0 => current_coeff <= COEFF1;
            when 1 => current_coeff <= COEFF2;
            when 2 => current_coeff <= COEFF3;
            when others => current_coeff <= (
                re => to_sfixed(0, fixed64'high, fixed64'low),
                im => to_sfixed(0, fixed64'high, fixed64'low)
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
                        current_result <= B;  -- Initial value = B
                        state <= COMPUTING;
                        step_counter <= 0;
                    end if;
                
                when COMPUTING =>
                    if step_counter < 5 then
                        if step_counter mod 2 = 0 then  -- Even steps: addition
                            current_result <= adder_out;
                        else                          -- Odd steps: multiplication
                            current_result <= mult_out;
                        end if;
                        step_counter <= step_counter + 1;
                    else
                        done_s <= '1';
                    end if;
            end case;
        end if;
    end process;

    done <= done_s;
    -- Apply final negation to the result
    P <= negate_cmatrixHigh(current_result);

end Behavioral;
