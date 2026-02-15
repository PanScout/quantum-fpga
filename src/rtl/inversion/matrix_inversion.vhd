library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
use work.qTypes.all;
use work.fixed_pkg.ALL;

entity matrix_inversion is
    Port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        start           : in  std_logic;
        input_matrix    : in  cmatrix;
        output_matrix   : out cmatrix;
        done            : out std_logic
    );
end matrix_inversion;

architecture TopLevel of matrix_inversion is
    component matrix_inversion_initial_guess is
        Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        A        : in  cmatrix;
        scaled_AT : out cmatrix
        );
    end component;

    component matrix_inversion_state_machine is
        Port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            start           : in  std_logic;
            input_matrix    : in  cmatrix;
            input_guess     : in  cmatrix;
            output_matrix   : out cmatrix;
            done            : out std_logic
        );
    end component;

    -- Internal signals
    signal initial_guess : cmatrix;
    signal inversion_done : std_logic;

begin
    -- Generate initial guess using scaled transpose method
    GUESS_CALCULATOR: matrix_inversion_initial_guess
    port map(
        clk => clk,
	reset => rst,
        A => input_matrix,
        scaled_AT => initial_guess
    );

    -- State machine-based Newton iteration core
    INVERSION_CORE: matrix_inversion_state_machine
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
