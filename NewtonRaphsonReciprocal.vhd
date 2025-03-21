library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.fixed_pkg.ALL;
use work.qTypes.all;

entity NewtonRaphsonReciprocal is
    Port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        start  : in  std_logic;
        X      : in  fixedHigh;  -- Input: N1*N2
        Y      : out fixedHigh;  -- Output: 1/(N1*N2)
        done   : out std_logic
        --error  : out std_logic  -- New error flag for division by zero
    );
end NewtonRaphsonReciprocal;

architecture Behavioral of NewtonRaphsonReciprocal is
    type state_type is (IDLE, INIT, ITERATE, FINISHED, ERROR_STATE);
    signal state      : state_type := IDLE;
    signal iteration  : integer range 0 to 19 := 0;
    signal X_reg      : fixedHigh;
    signal Y_current  : fixedHigh;
begin
    process(clk, reset)
        variable temp : fixedHigh;
    begin
        if reset = '1' then
            state <= IDLE;
            done <= '0';
            --error <= '0';
            Y <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    done <= '0';
                    --error <= '0';
                    if start = '1' then
                        X_reg <= X;
                        state <= INIT;
                    end if;

                -- Check for division by zero and use LUT-based initial guess
                when INIT =>
                    if X_reg = to_sfixed(0, X_reg) then
                        state <= ERROR_STATE;
                    else
                        -- Synthesizable initial guess (example: 3/4 * 2^(-n))
                        -- Replace with your LUT or approximation logic
                        Y_current <= resize(to_sfixed(1, fixedHigh'high, fixedHigh'low) / X_reg, fixedHigh'high, fixedHigh'low); -- Simplified for illustration
                        iteration <= 0;
                        state <= ITERATE;
                    end if;

                -- Newton-Raphson iterations (unchanged)
                when ITERATE =>
                    temp := resize(X_reg * Y_current, fixedHigh'high, fixedHigh'low);
                    temp := resize(to_sfixed(2, fixedHigh'high, fixedHigh'low) - temp, fixedHigh'high, fixedHigh'low);
                    temp := resize(Y_current * temp, fixedHigh'high, fixedHigh'low);
                    Y_current <= temp;

                    if iteration < 19 then
                        iteration <= iteration + 1;
                    else
                        state <= FINISHED;
                    end if;

                when FINISHED =>
                    Y <= Y_current;
                    done <= '1';
                    state <= IDLE;

                when ERROR_STATE =>
                    --error <= '1';
                    done <= '0';
                    state <= IDLE;
            end case;
        end if;
    end process;
end Behavioral;
