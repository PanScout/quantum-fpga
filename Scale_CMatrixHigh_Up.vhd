library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

entity Scale_CMatrixHigh_Up is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        B      : in  cmatrixHigh;
        S      : in  cfixedHigh;
        Result : out cmatrixHigh;
        done   : out std_logic
    );
end Scale_CMatrixHigh_Up;

architecture Behavioral of Scale_CMatrixHigh_Up is
    type state_type is (IDLE, INIT, SQUARING, EOE);
    signal state : state_type := IDLE;
    
    signal current_matrix : cmatrixHigh;
    signal next_matrix    : cmatrixHigh;
    signal counter        : natural := 0;
    
    component Matrix_By_Matrix_Multiplication_High is
        Port (
            A : in  cmatrixHigh;
            B : in  cmatrixHigh;
            C : out cmatrixHigh
        );
    end component;

begin
    Matrix_Multiplier: Matrix_By_Matrix_Multiplication_High
        port map (
            A => current_matrix,
            B => current_matrix,
            C => next_matrix
        );

    process(clk, reset)
        variable s_val : natural;
    begin
        if reset = '1' then
            state <= IDLE;
            done <= '0';
            -- Proper complex matrix initialization
            Result <= (others => (others => (
                re => to_sfixed(0.0, fixedHigh'high, fixedHigh'low),
                im => to_sfixed(0.0, fixedHigh'high, fixedHigh'low)
            )));
            current_matrix <= (others => (others => (
                re => to_sfixed(0.0, fixedHigh'high, fixedHigh'low),
                im => to_sfixed(0.0, fixedHigh'high, fixedHigh'low)
            )));
            counter <= 0;
            
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    state <= INIT;
                    done <= '0';
                    
                when INIT =>
                    s_val := to_integer(S.re);
                    
                    if s_val = 0 then
                        Result <= B;
                        done <= '1';
                        state <= EOE;
                    else
                        current_matrix <= B;
                        counter <= s_val - 1;  -- Adjust for first squaring
                        state <= SQUARING;
                    end if;
                    
                when SQUARING =>
                    if counter > 0 then
                        current_matrix <= next_matrix;
                        counter <= counter - 1;
                    else
                        Result <= next_matrix;  -- Capture final result
                        done <= '1';
                        state <= EOE;
                    end if;
                    
                when EOE =>
		    null;
                                   
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

end Behavioral;
