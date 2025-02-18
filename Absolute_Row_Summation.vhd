library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;

-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity Absolute_Row_Summation is
  port (
    A : in  cmatrixHigh;  -- 4�4 matrix when nQubits=2

    -- Output 1: The computed infinity norm in cfixedHigh (imag part = 0)
    rowSums : out cvectorHigh
  );
end entity Absolute_Row_Summation;

architecture Behavioral of Absolute_Row_Summation is

  --type partialSum_array is array (0 to numBasisStates-1, 0 to numBasisStates-1) of fixedHigh;
  constant DATA_WIDTH : natural := 64;  -- Adjust based on your actual needs
  type partialSum_array is array (0 to numBasisStates-1, 0 to numBasisStates-1) 
       of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal partialSum : partialSum_array;


begin

  gen_rows: for i in 0 to numBasisStates-1 generate
  begin

    gen_cols: for j in 0 to numBasisStates-1 generate
      signal abs_re : unsigned(DATA_WIDTH-1 downto 0);
      signal abs_im : unsigned(DATA_WIDTH-1 downto 0);
    begin

      -- Handle first column (j=0) separately to avoid j-1 = -1
      abs_re <= unsigned(abs(signed(A(i)(j).re)));
      abs_im <= unsigned(abs(signed(A(i)(j).im)));
      gen_j0: if j = 0 generate
        --BS_j0: block
          --signal val : fixedHigh;
        --begin
          --val <= resize(abs(A(i)(j).re) + abs(A(i)(j).im), fixedHigh'high, fixedHigh'low);

          --partialSum(i, j) <= val;
        partialSum(i, j) <= std_logic_vector(abs_re + abs_im);
        --end block BS_j0;
      end generate gen_j0;

      -- Handle columns j > 0
      gen_j_others: if j > 0 generate
        partialSum(i, j) <= std_logic_vector(
          unsigned(partialSum(i, j-1)) + 
          unsigned(abs_re) + 
          unsigned(abs_im)
        );
        --BS_j: block
          --signal val : fixedHigh;
        --begin
          --val <= resize(abs(A(i)(j).re) + abs(A(i)(j).im), fixedHigh'high, fixedHigh'low);
          --partialSum(i, j) <= resize(partialSum(i, j-1) + val, fixedHigh'high, fixedHigh'low);
        --end block BS_j;
      end generate gen_j_others;

    end generate gen_cols;

    rowSums(i).re <= partialSum(i, numBasisStates-1);
    --rowSums(i).im <= to_sfixed(0.0, fixedHigh'high, fixedHigh'low);
    rowSums(i).im <= (others => '0');

  end generate gen_rows;

end architecture Behavioral;
