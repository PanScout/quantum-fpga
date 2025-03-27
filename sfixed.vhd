library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

----------------------------------------------------------------------------
-- Package: sfixed
-- A minimal fixed64?point package that supports the four basic operators
-- (+, -, *, /), a compatibility resize function, an absolute value
-- function, and now the basic comparison operators.
----------------------------------------------------------------------------
package sfixed is

  -- Define our fixed64?point type.
  type sfixed is array (integer range <>) of std_logic;

  -- Four basic arithmetic operators.
  function "+" (L, R : sfixed) return sfixed;
  function "-" (L, R : sfixed) return sfixed;
  function "*" (L, R : sfixed) return sfixed;
  function "/" (L, R : sfixed) return sfixed;

  -- Compatibility resize function.
  -- The extra arguments (integer_size and decimal_size) are ignored.
function resize(num : sfixed; target_high: integer; target_low: integer) return sfixed;

  -- Helper conversion functions: These convert between our sfixed type and the signed type.
  function to_signed_sf(x: sfixed) return signed;
  function to_sfixed(x: signed; target: sfixed) return sfixed;

  -- New overload: Convert a signed value to an sfixed with a target range defined by left_index downto right_index.
  function to_sfixed(x: signed; left_index: integer; right_index: integer) return sfixed;

  -- Absolute value function.
  function abss(x: sfixed) return sfixed;
  
  -- Comparison operators
  function "=" (L, R: sfixed) return boolean;
  function "/=" (L, R: sfixed) return boolean;
  function "<" (L, R: sfixed) return boolean;
  function "<=" (L, R: sfixed) return boolean;
  function ">" (L, R: sfixed) return boolean;
  function ">=" (L, R: sfixed) return boolean;

  -- Convert sfixed to integer (truncates fractional bits)
  function to_integer(x: sfixed) return integer;
  -- Arithmetic shift right for sfixed (preserves sign)
  function shift_right(arg: sfixed; count: natural) return sfixed;

  function to_natural(x: sfixed) return natural;

end package sfixed;

----------------------------------------------------------------------------
package body sfixed is

  -- Convert an sfixed (with arbitrary integer range) to a signed vector with natural indices.
  function to_signed_sf(x: sfixed) return signed is
    variable result: signed(x'length - 1 downto 0);
    variable i: integer;
  begin
    -- Assume x is declared in descending order (e.g. 14 downto -10).
    for i in 0 to x'length - 1 loop
      result(result'high - i) := x(x'high - i);
    end loop;
    return result;
  end function;

  -- Convert a signed vector to an sfixed with the same length as the target.
  function to_sfixed(x: signed; target: sfixed) return sfixed is
    variable result: sfixed(target'range);
    variable tmp: std_logic_vector(x'length - 1 downto 0) := std_logic_vector(x);
    variable i: integer;
  begin
    for i in 0 to x'length - 1 loop
      result(target'high - i) := tmp(i);
    end loop;
    return result;
  end function;

  -- Overloaded conversion: Convert a signed value to an sfixed with range defined by left_index downto right_index.
  function to_sfixed(x: signed; left_index: integer; right_index: integer) return sfixed is
    variable target: sfixed(left_index downto right_index) := (others => '0');
  begin
    target := to_sfixed(x, target);
    return target;
  end function;

  -- Addition: Convert operands to signed, add them, and convert back.
  function "+" (L, R : sfixed) return sfixed is
    variable Ls, Rs: signed(L'length - 1 downto 0);
    variable sum: signed(L'length - 1 downto 0);
  begin
    Ls := to_signed_sf(L);
    Rs := to_signed_sf(R);
    sum := Ls + Rs;
    return to_sfixed(sum, L);
  end function;

  -- Subtraction: Convert operands to signed, subtract, and convert back.
  function "-" (L, R : sfixed) return sfixed is
    variable Ls, Rs: signed(L'length - 1 downto 0);
    variable diff: signed(L'length - 1 downto 0);
  begin
    Ls := to_signed_sf(L);
    Rs := to_signed_sf(R);
    diff := Ls - Rs;
    return to_sfixed(diff, L);
  end function;

  -- Helper: Arithmetic shift right for a signed vector (without using sra).
  function arith_shift_right(X: signed; shift: integer) return signed is
    variable Y: signed(X'range) := (others => X(X'high));
    variable i: integer;
  begin
    if shift = 0 then
      return X;
    end if;
    for i in X'range loop
      if i + shift <= X'high then
         Y(i) := X(i + shift);
      else
         Y(i) := X(X'high);  -- replicate the sign bit
      end if;
    end loop;
    return Y;
  end function;

  -- Convert sfixed to integer by truncating fractional bits
  function to_integer(x: sfixed) return integer is
    variable s       : signed(x'length - 1 downto 0);
    variable F       : integer;
  begin
    s := to_signed_sf(x);  -- Convert to signed
    -- Calculate fractional bit count
    if x'low < 0 then
      F := -x'low;
    else
      F := 0;
    end if;
    -- Shift right to discard fractional bits
    s := shift_right(s, F);
    -- Convert to integer
    return to_integer(s);
  end function;

  -- Arithmetic shift right for sfixed
  function shift_right(arg: sfixed; count: natural) return sfixed is
    variable s       : signed(arg'length - 1 downto 0);
    variable shifted : signed(arg'length - 1 downto 0);
  begin
    s := to_signed_sf(arg);  -- Convert to signed
    shifted := shift_right(s, count);  -- Use numeric_std's arithmetic shift
    return to_sfixed(shifted, arg);  -- Convert back to sfixed
  end function;


  -- Helper: Arithmetic shift left for a signed vector (without using sll).
  function arith_shift_left(X: signed; shift: integer) return signed is
    variable Y: signed(X'range) := (others => '0');
    variable i: integer;
  begin
    if shift = 0 then
      return X;
    end if;
    for i in X'range loop
      if i - shift >= X'low then
         Y(i) := X(i - shift);
      else
         Y(i) := '0';
      end if;
    end loop;
    return Y;
  end function;

  -- Multiplication:
  -- For an sfixed number defined over (I downto -F) with total width N = I - (-F) + 1,
  -- assume F = -L'low (if L'low is negative). Extend operands to 2*N bits, multiply,
  -- arithmetic shift right by F bits, then truncate to N bits.
  --function "*" (L, R : sfixed) return sfixed is
    --constant N: integer := L'length;
    --variable F: integer;
    --variable L_ext, R_ext: signed((N * 2) - 1 downto 0);
    --variable product: signed((N * 2) - 1 downto 0);
    --variable result: signed(N - 1 downto 0);
  --begin
    --if L'low < 0 then
      --F := -L'low;
    --else
      --F := 0;
    --end if;
    --L_ext := IEEE.NUMERIC_STD.resize(to_signed_sf(L), N * 2);
    --R_ext := IEEE.NUMERIC_STD.resize(to_signed_sf(R), N * 2);
    --product := L_ext * R_ext;
    --product := arith_shift_right(product, F);
    --result := product(product'high downto product'high - N + 1);
    --return to_sfixed(result, L);
  --end function;

function "*" (L, R : sfixed) return sfixed is
  constant N : integer := L'length;
  variable F : integer;
  variable L_fractional, R_fractional : integer;
  variable L_ext, R_ext : signed(N - 1 downto 0);  -- Match input size
  variable product : signed((2 * N) - 1 downto 0);  -- Proper product size
  variable result : signed(N - 1 downto 0);
begin
  -- Calculate fractional bits using sequential if statements
  if L'low < 0 then
    L_fractional := -L'low;
  else
    L_fractional := 0;
  end if;

  if R'low < 0 then
    R_fractional := -R'low;
  else
    R_fractional := 0;
  end if;

  F := L_fractional + R_fractional;

  -- Convert to signed WITHOUT resizing
  L_ext := to_signed_sf(L);
  R_ext := to_signed_sf(R);

  -- Multiply with proper product size (2N bits)
  product := L_ext * R_ext;

  -- Scale and truncate correctly
  product := arith_shift_right(product, F);
  result := product(product'high downto product'high - N + 1);

  return to_sfixed(result, L);
end function;

--function "*" (L, R : sfixed) return sfixed is
  --constant N: integer := L'length;
  --variable F: integer;
  --variable L_fractional, R_fractional: integer;
  --variable L_ext: signed((N*2) - 1 downto 0);
  --variable R_ext: signed((N) - 1 downto 0);
  --variable product: signed((N) - 1 downto 0);
  --variable result: signed(N - 1 downto 0);
--begin
  -- Calculate fractional bits using sequential if statements
  --if L'low < 0 then
    --L_fractional := -L'low;
  --else
    --L_fractional := 0;
  --end if;

  --if R'low < 0 then
    --R_fractional := -R'low;
  --else
   -- R_fractional := 0;
  ---end if;

  --F := L_fractional + R_fractional;

  --L_ext := IEEE.NUMERIC_STD.resize(to_signed_sf(L), N*2);
 -- R_ext := IEEE.NUMERIC_STD.resize(to_signed_sf(R), N);
  --product := L_ext * R_ext;
  --product := arith_shift_right(product, F);
  --result := product(product'high downto product'high - N + 1);
  --return to_sfixed(result, L);
--end function;

  -- Division:
  -- Extend L to 2*N bits, shift left by F bits (with F = -L'low if negative) to preserve fractional resolution,
  -- perform integer division with R extended to 2*N bits, then truncate to N bits.
  function "/" (L, R : sfixed) return sfixed is
    constant N: integer := L'length;
    variable F: integer;
    variable L_ext: signed((N * 2) - 1 downto 0);
    variable dividend: signed((N * 2) - 1 downto 0);
    variable divisor: signed((N * 2) - 1 downto 0);
    variable quotient: signed((N * 2) - 1 downto 0);
    variable result: signed(N - 1 downto 0);
  begin
    if L'low < 0 then
      F := -L'low;
    else
      F := 0;
    end if;
    L_ext := IEEE.NUMERIC_STD.resize(to_signed_sf(L), N * 2);
    dividend := arith_shift_left(L_ext, F);
    divisor := IEEE.NUMERIC_STD.resize(to_signed_sf(R), N * 2);
    quotient := dividend / divisor;
    result := quotient(quotient'high downto quotient'high - N + 1);
    return to_sfixed(result, L);
  end function;

--function resize(num : sfixed; integer_size : integer; decimal_size : integer) return sfixed is
  --constant new_left  : integer := integer_size - 1;
  --constant new_right : integer := -decimal_size;
  --constant new_length: integer := new_left - new_right + 1;
  --variable temp    : signed(num'length - 1 downto 0);
  --variable resized : signed(new_length - 1 downto 0);
--begin
  -- Convert the input to a signed vector
  --temp := to_signed_sf(num);
  -- Resize the signed vector to the new total length (with sign extension or truncation)
  --resized := IEEE.NUMERIC_STD.resize(temp, new_length);
  -- Convert back to sfixed with the target range
  --return to_sfixed(resized, new_left, new_right);
--end function resize;

function resize(num : sfixed; target_high: integer; target_low: integer) return sfixed is
  constant new_length: integer := target_high - target_low + 1;
  variable temp    : signed(num'length - 1 downto 0);
  variable resized : signed(new_length - 1 downto 0);
begin
  -- Convert the input sfixed to a signed vector.
  temp := to_signed_sf(num);
  -- Use IEEE.NUMERIC_STD.resize to adjust the vector length.
  resized := IEEE.NUMERIC_STD.resize(temp, new_length);
  -- Convert the resized signed vector back to sfixed with the given target range.
  return to_sfixed(resized, target_high, target_low);
end function resize;

  -- Absolute value: Return the absolute value of x.
  function abss(x: sfixed) return sfixed is
    variable sx: signed(x'length - 1 downto 0);
    variable res: signed(x'length - 1 downto 0);
  begin
    sx := to_signed_sf(x);
    if sx(sx'high) = '1' then
      res := -sx;
    else
      res := sx;
    end if;
    return to_sfixed(res, x);
  end function;
  
  -- Comparison operators

  -- Equality operator
  function "=" (L, R: sfixed) return boolean is
  begin
    return to_signed_sf(L) = to_signed_sf(R);
  end function;

  -- Inequality operator
  function "/=" (L, R: sfixed) return boolean is
  begin
    return to_signed_sf(L) /= to_signed_sf(R);
  end function;

  -- Less-than operator
  function "<" (L, R: sfixed) return boolean is
  begin
    return to_signed_sf(L) < to_signed_sf(R);
  end function;

  -- Less-than or equal operator
  function "<=" (L, R: sfixed) return boolean is
  begin
    return to_signed_sf(L) <= to_signed_sf(R);
  end function;

  -- Greater-than operator
  function ">" (L, R: sfixed) return boolean is
  begin
    return to_signed_sf(L) > to_signed_sf(R);
  end function;

  -- Greater-than or equal operator
  function ">=" (L, R: sfixed) return boolean is
  begin
    return to_signed_sf(L) >= to_signed_sf(R);
  end function;

function to_natural(x: sfixed) return natural is
  variable temp: integer;
begin
  temp := to_integer(x);
  if temp < 0 then
    return 0;  -- Alternatively, you could assert or handle negative values as needed.
  else
    return natural(temp);
  end if;
end function to_natural;


end package body sfixed;

