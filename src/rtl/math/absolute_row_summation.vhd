library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

-------------------------------------------------------------------------------
-- Entity
-------------------------------------------------------------------------------
entity absolute_row_summation is
  port (
    A : in  cmatrix;  -- 4�4 matrix when nQubits=2

    -- Output 1: The computed infinity norm in csfixed36 (imag part = 0)
    rowSums : out cvector
  );
end entity absolute_row_summation;


architecture Behavioral of absolute_row_summation is

  type partialSum_array is array (0 to dimension-1, 0 to dimension-1) of sfixed36;
  signal partialSum : partialSum_array;
   signal my_fixed : sfixed(14 downto -10);

begin

  gen_rows: for i in 0 to dimension-1 generate
  begin

    gen_cols: for j in 0 to dimension-1 generate
    begin

      -- Handle first column (j=0) separately to avoid j-1 = -1
      gen_j0: if j = 0 generate
        BS_j0: block
          signal val : sfixed36;
        begin
          val <= resize(abs(A(i)(j).re) + abs(A(i)(j).im), sfixed36'high, sfixed36'low);
          partialSum(i, j) <= val;
        end block BS_j0;
      end generate gen_j0;

      -- Handle columns j > 0
      gen_j_others: if j > 0 generate
        BS_j: block
          signal val : sfixed36;
        begin
          val <= resize(abs(A(i)(j).re) + abs(A(i)(j).im), sfixed36'high, sfixed36'low);
          partialSum(i, j) <= resize(partialSum(i, j-1) + val, sfixed36'high, sfixed36'low);
        end block BS_j;
      end generate gen_j_others;

    end generate gen_cols;

    rowSums(i).re <= partialSum(i, dimension-1);
    --rowSums(i).im <= b"0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    rowSums(i).im <= to_sfixed(0, sfixed36'high, sfixed36'low);

  end generate gen_rows;

end architecture Behavioral;
