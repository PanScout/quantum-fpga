library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

entity padeDenominator is
    Port (
        clk   : in  std_logic;
        reset : in  std_logic;
        start : in  std_logic;
        B     : in  cmatrixHigh;
        P     : out cmatrixHigh;
        done  : out std_logic
    );
end padeDenominator;

architecture Behavioral of padeDenominator is

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

    -- Horner's method coefficients for (((B-12)*B+60)*B-120)
    constant COEFF1 : cfixedHigh := (  -- -12
        re => "1111111111010000000000000000000000000000000000000000000000000000",  -- Adjust binary representation
        im => (others => '0')                                                     -- based on your fixed-point format
    );
    constant COEFF2 : cfixedHigh := (  -- +60
        re => "0000000011110000000000000000000000000000000000000000000000000000",
        im => (others => '0')
    );
    constant COEFF3 : cfixedHigh := (  -- -120
        re => "1111111000100000000000000000000000000000000000000000000000000000",
        im => (others => '0')
    );

    type state_type is (IDLE, COMPUTING);
    signal state : state_type := IDLE;
    signal current_result, B_reg : cmatrixHigh;
    signal step_counter : integer range 0 to 5 := 0;  -- Reduced counter range
    signal current_coeff : cfixedHigh;
    signal adder_out, mult_out : cmatrixHigh;
    signal done_s : std_logic;

    function init_cmatrixHigh_zero return cmatrixHigh is
        variable matrix : cmatrixHigh;
    begin
        for i in matrix'range loop
            for j in matrix(i)'range loop
                matrix(i)(j) := (
                    re => (others => '0'),
                    im => (others => '0')
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
        case step_counter/2 is  -- Coefficient selection logic
            when 0 => current_coeff <= COEFF1;
            when 1 => current_coeff <= COEFF2;
            when 2 => current_coeff <= COEFF3;
            when others => current_coeff <= (
                re => (others => '0'),
                im => (others => '0')
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
    P <= current_result;

end Behavioral;
