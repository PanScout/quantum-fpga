library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
use work.qTypes.all;

entity Matrix_Inversion is
    Port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        input_matrix    : in  cmatrixHigh;
        output_matrix   : out cmatrixHigh;
        done            : out std_logic
    );
end Matrix_Inversion;

architecture TopLevel of Matrix_Inversion is
    component Newtons_Guess is
        Port (
            A          : in  cmatrixHigh;
            scaled_AT  : out cmatrixHigh
        );
    end component;

    component Matrix_Inversion_State_Machine is
        Port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            start           : in  std_logic;
            input_matrix    : in  cmatrixHigh;
            input_guess     : in  cmatrixHigh;
            output_matrix   : out cmatrixHigh;
            done            : out std_logic
        );
    end component;

    -- Internal signals
    signal initial_guess : cmatrixHigh;
    signal inversion_done : std_logic;

begin
    -- Generate initial guess using scaled transpose method
    GUESS_CALCULATOR: Newtons_Guess
    port map(
        A => input_matrix,
        scaled_AT => initial_guess
    );

    -- State machine-based Newton iteration core
    INVERSION_CORE: Matrix_Inversion_State_Machine
    port map(
        clk => clk,
        rst => rst,
        start => start,
        input_matrix => input_matrix,
        input_guess => initial_guess,
        output_matrix => output_matrix,
        done => inversion_done
    );

    -- Output control
    done <= inversion_done;

end TopLevel;
