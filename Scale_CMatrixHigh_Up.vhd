library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed.ALL;
use work.qTypes.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

entity Scale_CMatrixHigh_Up is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
	start : in std_logic;
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
                re => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
                im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            )));
            current_matrix <= (others => (others => (
                re => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
                im => "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
            )));
            counter <= 0;
            
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    --done <= '0';
		    if start = '1' then
                        state <= INIT;
                    end if;
                    
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
		    if start = '0' then
                        state <= IDLE;
                    end if;
                                   
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

end Behavioral;
