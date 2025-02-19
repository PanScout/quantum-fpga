library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Matrix_Inversion_State_Machine is
    Port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        input_matrix    : in  cmatrixHigh;
        input_guess     : in  cmatrixHigh;
        output_matrix   : out cmatrixHigh;
        done            : out std_logic
    );
end Matrix_Inversion_State_Machine;

architecture Behavioral of Matrix_Inversion_State_Machine is
    component Matrix_By_Matrix_Multiplication_High is
        Port (
            A : in  cmatrixHigh;
            B : in  cmatrixHigh;
            C : out cmatrixHigh
        );
    end component;

    type state_type is (
        IDLE, INIT, LOAD_AX, CALC_AX, 
        LOAD_2I, SUB_2I, LOAD_XNEXT, 
        CALC_XNEXT, UPDATE_X, CHECK_CONV, FINISH
    );

    signal state : state_type := IDLE;
    
    -- Matrix storage registers
    signal Xk, Xnext, AX, twoI_minus_AX : cmatrixHigh;
    signal matA, matB, matC : cmatrixHigh;
    
    -- Control signals
    signal mult_start, mult_done : std_logic := '0';
    signal iteration : natural range 0 to 50 := 0;
    
    -- Error calculation signals
    signal error_norm : real := 0.0;
    
begin

    -- Instantiate matrix multiplier
    MAT_MULT: Matrix_By_Matrix_Multiplication_High
    port map (
        A => matA,
        B => matB,
        C => matC
    );

    process(clk)
        variable identity : cmatrixHigh;
        variable tmp_re, tmp_im : real;
        variable error_sum : real;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
                done <= '0';
                Xk <= (others => (others => (
                    re => (others => '0'),
                    im => (others => '0'))));
                iteration <= 0;
                mult_start <= '0';
                error_norm <= 0.0;
            else
                case state is
                    when IDLE =>
                        done <= '0';
                        if start = '1' then
			    --matA <= input_matrix;
                            Xk <= input_guess;
                            iteration <= 0;
                            state <= INIT;
                        end if;
                        
                    when INIT =>
                        matA <= input_matrix;
                        matB <= Xk;
                        mult_start <= '1';
                        state <= LOAD_AX;
                        
                    when LOAD_AX =>
                        mult_start <= '0';
                        state <= CALC_AX;
                        
                    when CALC_AX =>
                        AX <= matC;
                        state <= LOAD_2I;
                        
                    when LOAD_2I =>
                        for i in 0 to numBasisStates-1 loop
                            for j in 0 to numBasisStates-1 loop
                                if i = j then
                                    identity(i)(j).re := to_sfixed(2.0, fixedHigh'high, fixedHigh'low);
                                    identity(i)(j).im := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
                                else
                                    identity(i)(j).re := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
                                    identity(i)(j).im := to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
                                end if;
                            end loop;
                        end loop;
                        matA <= identity;
                        matB <= AX;
                        state <= SUB_2I;
                        
                    when SUB_2I =>
                        for i in 0 to numBasisStates-1 loop
                            for j in 0 to numBasisStates-1 loop
                                twoI_minus_AX(i)(j).re <= resize(
                                    matA(i)(j).re - matB(i)(j).re,
                                    fixedHigh'high, fixedHigh'low
                                );
                                twoI_minus_AX(i)(j).im <= resize(
                                    matA(i)(j).im - matB(i)(j).im,
                                    fixedHigh'high, fixedHigh'low
                                );
                            end loop;
                        end loop;
                        state <= LOAD_XNEXT;
                        
                    when LOAD_XNEXT =>
                        matA <= Xk;
                        matB <= twoI_minus_AX;
                        mult_start <= '1';
                        state <= CALC_XNEXT;
                        
                    when CALC_XNEXT =>
                        mult_start <= '0';
                        Xnext <= matC;
                        state <= UPDATE_X;
                        
                    when UPDATE_X =>
                        Xk <= Xnext;
                        iteration <= iteration + 1;

                        state <= CHECK_CONV;
                        
                    when CHECK_CONV =>
                        -- Calculate residual norm ||AX - I||
                        error_sum := 0.0;
                        for i in 0 to numBasisStates-1 loop
                            for j in 0 to numBasisStates-1 loop
                                -- Convert fixed-point to real
                                tmp_re := to_real(AX(i)(j).re);
                                tmp_im := to_real(AX(i)(j).im);
                                
                                -- Subtract identity matrix
                                if i = j then
                                    tmp_re := tmp_re - 1.0;
                                end if;
                                
                                -- Accumulate squared magnitude
                                error_sum := error_sum + (tmp_re**2 + tmp_im**2);
                            end loop;
                        end loop;
                        --error_norm <= sqrt(error_sum);
                        
                        -- Simulation-only print statement
                        report "Iteration: " & integer'image(iteration) 
                            & " Error: " & real'image(error_norm)
                            severity note;
                            
                        if iteration < 40 then
                            state <= INIT;
                        else
                            state <= FINISH;
                        end if;
                        
                    when FINISH =>
                        output_matrix <= Xk;
                        done <= '1';
                        state <= IDLE;
                        
                end case;
            end if;
        end if;
    end process;

end Behavioral;
