library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;
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

  type partialSum_array is array (0 to numBasisStates-1, 0 to numBasisStates-1) of fixedHigh;
  signal partialSum : partialSum_array;

begin

  gen_rows: for i in 0 to numBasisStates-1 generate
  begin

    gen_cols: for j in 0 to numBasisStates-1 generate
    begin

      -- Handle first column (j=0) separately to avoid j-1 = -1
      gen_j0: if j = 0 generate
        BS_j0: block
          signal val : fixedHigh;
        begin
          val <= resize(abs(A(i)(j).re) + abs(A(i)(j).im), fixedHigh'high, fixedHigh'low);
          partialSum(i, j) <= val;
        end block BS_j0;
      end generate gen_j0;

      -- Handle columns j > 0
      gen_j_others: if j > 0 generate
        BS_j: block
          signal val : fixedHigh;
        begin
          val <= resize(abs(A(i)(j).re) + abs(A(i)(j).im), fixedHigh'high, fixedHigh'low);
          partialSum(i, j) <= resize(partialSum(i, j-1) + val, fixedHigh'high, fixedHigh'low);
        end block BS_j;
      end generate gen_j_others;

    end generate gen_cols;

    rowSums(i).re <= partialSum(i, numBasisStates-1);
    rowSums(i).im <= to_sfixed(0.0, fixedHigh'high, fixedHigh'low);

  end generate gen_rows;

end architecture Behavioral;
