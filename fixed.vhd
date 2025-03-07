use STD.TEXTIO.all;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--use IEEE.fixed_float_types.all;

package fixed is

  type fixed_round_style_type is (fixed_round, fixed_truncate);
  type fixed_overflow_style_type is (fixed_saturate, fixed_wrap);

  -- Constants replacing the generic parameters
  constant fixed_round_style    : fixed_round_style_type    := fixed_round;
  constant fixed_overflow_style : fixed_overflow_style_type := fixed_saturate;
  constant fixed_guard_bits     : NATURAL                   := 3;
  constant no_warning           : BOOLEAN                   := false;

  -- Author and Copyright Notice
  constant CopyRightNotice : STRING :=
    "Copyright IEEE P1076 WG. Licensed Apache 2.0";

  -- base Unsigned fixed point type, downto direction assumed
  type UNRESOLVED_ufixed is array (INTEGER range <>) of STD_ULOGIC;
  -- base Signed fixed point type, downto direction assumed
  type UNRESOLVED_sfixed is array (INTEGER range <>) of STD_ULOGIC;
  
  -- Declare UNRESOLVED_SIGNED as an alias for the standard 'signed' type
  subtype UNRESOLVED_SIGNED is signed;
  subtype UNRESOLVED_UNSIGNED is unsigned;
  
  alias U_ufixed is UNRESOLVED_ufixed;
  alias U_sfixed is UNRESOLVED_sfixed;

  --subtype ufixed is (resolved) UNRESOLVED_ufixed;
  --subtype sfixed is (resolved) UNRESOLVED_sfixed;
  
  subtype ufixed is UNRESOLVED_ufixed;
  subtype sfixed is UNRESOLVED_sfixed;


  --===========================================================================
  -- Arithmetic Operators:
  --===========================================================================

  -- Absolute value, 2's complement
  function "abs" (arg : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Negation, 2's complement
  function "-" (arg : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Addition
  function "+" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "+" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Subtraction
  function "-" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "-" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Multiplication
  function "*" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "*" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Division
  function "/" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "/" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Remainder
  function "rem" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "rem" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Modulo
  function "mod" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "mod" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  ----------------------------------------------------------------------------
  -- In these routines the "real" or "natural" (integer) are converted into a
  -- fixed point number and then the operation is performed.
  ----------------------------------------------------------------------------

  function "+" (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function "+" (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "+" (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function "+" (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  function "-" (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function "-" (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "-" (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function "-" (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  function "*" (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function "*" (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "*" (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function "*" (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  function "/" (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function "/" (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "/" (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function "/" (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  function "rem" (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function "rem" (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "rem" (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function "rem" (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  function "mod" (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function "mod" (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "mod" (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function "mod" (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  function "+" (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function "+" (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "+" (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function "+" (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  function "-" (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function "-" (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "-" (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function "-" (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  function "*" (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function "*" (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "*" (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function "*" (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  function "/" (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function "/" (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "/" (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function "/" (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  function "rem" (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function "rem" (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "rem" (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function "rem" (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  function "mod" (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function "mod" (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "mod" (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function "mod" (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- This version of divide gives the user more control
  function divide (
    l, r                 : UNRESOLVED_ufixed;
    constant round_style : fixed_round_style_type := fixed_round_style;
    constant guard_bits  : NATURAL                := fixed_guard_bits)
    return UNRESOLVED_ufixed;

  function divide (
    l, r                 : UNRESOLVED_sfixed;
    constant round_style : fixed_round_style_type := fixed_round_style;
    constant guard_bits  : NATURAL                := fixed_guard_bits)
    return UNRESOLVED_sfixed;

  -- These functions return 1/X
  function reciprocal (
    arg                  : UNRESOLVED_ufixed;
    constant round_style : fixed_round_style_type := fixed_round_style;
    constant guard_bits  : NATURAL                := fixed_guard_bits)
    return UNRESOLVED_ufixed;

  function reciprocal (
    arg                  : UNRESOLVED_sfixed;
    constant round_style : fixed_round_style_type := fixed_round_style;
    constant guard_bits  : NATURAL                := fixed_guard_bits)
    return UNRESOLVED_sfixed;

  -- REM function
  function remainder (
    l, r                 : UNRESOLVED_ufixed;
    constant round_style : fixed_round_style_type := fixed_round_style;
    constant guard_bits  : NATURAL                := fixed_guard_bits)
    return UNRESOLVED_ufixed;

  function remainder (
    l, r                 : UNRESOLVED_sfixed;
    constant round_style : fixed_round_style_type := fixed_round_style;
    constant guard_bits  : NATURAL                := fixed_guard_bits)
    return UNRESOLVED_sfixed;

  -- mod function
  function modulo (
    l, r                 : UNRESOLVED_ufixed;
    constant round_style : fixed_round_style_type := fixed_round_style;
    constant guard_bits  : NATURAL                := fixed_guard_bits)
    return UNRESOLVED_ufixed;

  function modulo (
    l, r                    : UNRESOLVED_sfixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style;
    constant guard_bits     : NATURAL                   := fixed_guard_bits)
    return UNRESOLVED_sfixed;

  -- Procedure for accumulator function.
  procedure add_carry (
    L, R   : in  UNRESOLVED_ufixed;
    c_in   : in  STD_ULOGIC;
    result : out UNRESOLVED_ufixed;
    c_out  : out STD_ULOGIC);

  procedure add_carry (
    L, R   : in  UNRESOLVED_sfixed;
    c_in   : in  STD_ULOGIC;
    result : out UNRESOLVED_sfixed;
    c_out  : out STD_ULOGIC);

  function scalb (y : UNRESOLVED_ufixed; N : INTEGER) return UNRESOLVED_ufixed;
  function scalb (y : UNRESOLVED_ufixed; N : UNRESOLVED_SIGNED) return UNRESOLVED_ufixed;
  function scalb (y : UNRESOLVED_sfixed; N : INTEGER) return UNRESOLVED_sfixed;
  function scalb (y : UNRESOLVED_sfixed; N : UNRESOLVED_SIGNED) return UNRESOLVED_sfixed;

  function Is_Negative (arg : UNRESOLVED_sfixed) return BOOLEAN;

  --===========================================================================
  -- Comparison Operators
  --===========================================================================

  function ">"  (l, r : UNRESOLVED_ufixed) return BOOLEAN;
  function ">"  (l, r : UNRESOLVED_sfixed) return BOOLEAN;
  function "<"  (l, r : UNRESOLVED_ufixed) return BOOLEAN;
  function "<"  (l, r : UNRESOLVED_sfixed) return BOOLEAN;
  function "<=" (l, r : UNRESOLVED_ufixed) return BOOLEAN;
  function "<=" (l, r : UNRESOLVED_sfixed) return BOOLEAN;
  function ">=" (l, r : UNRESOLVED_ufixed) return BOOLEAN;
  function ">=" (l, r : UNRESOLVED_sfixed) return BOOLEAN;
  function "="  (l, r : UNRESOLVED_ufixed) return BOOLEAN;
  function "="  (l, r : UNRESOLVED_sfixed) return BOOLEAN;
  function "/=" (l, r : UNRESOLVED_ufixed) return BOOLEAN;
  function "/=" (l, r : UNRESOLVED_sfixed) return BOOLEAN;

  function "="  (l, r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "/=" (l, r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function ">"  (l, r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function ">=" (l, r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "<"  (l, r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "<=" (l, r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "="  (l, r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "/=" (l, r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function ">"  (l, r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function ">=" (l, r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "<"  (l, r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "<=" (l, r : UNRESOLVED_sfixed) return STD_ULOGIC;

  function std_match (l, r : UNRESOLVED_ufixed) return BOOLEAN;
  function std_match (l, r : UNRESOLVED_sfixed) return BOOLEAN;

  function maximum (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function minimum (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function maximum (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function minimum (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  ----------------------------------------------------------------------------
  -- Comparisons with NATURAL
  ----------------------------------------------------------------------------

  function "="  (l : UNRESOLVED_ufixed; r : NATURAL) return BOOLEAN;
  function "/=" (l : UNRESOLVED_ufixed; r : NATURAL) return BOOLEAN;
  function ">=" (l : UNRESOLVED_ufixed; r : NATURAL) return BOOLEAN;
  function "<=" (l : UNRESOLVED_ufixed; r : NATURAL) return BOOLEAN;
  function ">"  (l : UNRESOLVED_ufixed; r : NATURAL) return BOOLEAN;
  function "<"  (l : UNRESOLVED_ufixed; r : NATURAL) return BOOLEAN;

  function "="  (l : NATURAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function "/=" (l : NATURAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function ">=" (l : NATURAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function "<=" (l : NATURAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function ">"  (l : NATURAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function "<"  (l : NATURAL; r : UNRESOLVED_ufixed) return BOOLEAN;

  function "="  (l : UNRESOLVED_ufixed; r : NATURAL) return STD_ULOGIC;
  function "/=" (l : UNRESOLVED_ufixed; r : NATURAL) return STD_ULOGIC;
  function ">=" (l : UNRESOLVED_ufixed; r : NATURAL) return STD_ULOGIC;
  function "<=" (l : UNRESOLVED_ufixed; r : NATURAL) return STD_ULOGIC;
  function ">"  (l : UNRESOLVED_ufixed; r : NATURAL) return STD_ULOGIC;
  function "<"  (l : UNRESOLVED_ufixed; r : NATURAL) return STD_ULOGIC;

  function "="  (l : NATURAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "/=" (l : NATURAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function ">=" (l : NATURAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "<=" (l : NATURAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function ">"  (l : NATURAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "<"  (l : NATURAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;

  function maximum (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function minimum (l : UNRESOLVED_ufixed; r : NATURAL) return UNRESOLVED_ufixed;
  function maximum (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function minimum (l : NATURAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  ----------------------------------------------------------------------------
  -- Comparisons with REAL
  ----------------------------------------------------------------------------

  function "="  (l : UNRESOLVED_ufixed; r : REAL) return BOOLEAN;
  function "/=" (l : UNRESOLVED_ufixed; r : REAL) return BOOLEAN;
  function ">=" (l : UNRESOLVED_ufixed; r : REAL) return BOOLEAN;
  function "<=" (l : UNRESOLVED_ufixed; r : REAL) return BOOLEAN;
  function ">"  (l : UNRESOLVED_ufixed; r : REAL) return BOOLEAN;
  function "<"  (l : UNRESOLVED_ufixed; r : REAL) return BOOLEAN;

  function "="  (l : REAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function "/=" (l : REAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function ">=" (l : REAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function "<=" (l : REAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function ">"  (l : REAL; r : UNRESOLVED_ufixed) return BOOLEAN;
  function "<"  (l : REAL; r : UNRESOLVED_ufixed) return BOOLEAN;

  function "="  (l : UNRESOLVED_ufixed; r : REAL) return STD_ULOGIC;
  function "/=" (l : UNRESOLVED_ufixed; r : REAL) return STD_ULOGIC;
  function ">=" (l : UNRESOLVED_ufixed; r : REAL) return STD_ULOGIC;
  function "<=" (l : UNRESOLVED_ufixed; r : REAL) return STD_ULOGIC;
  function ">"  (l : UNRESOLVED_ufixed; r : REAL) return STD_ULOGIC;
  function "<"  (l : UNRESOLVED_ufixed; r : REAL) return STD_ULOGIC;

  function "="  (l : REAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "/=" (l : REAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function ">=" (l : REAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "<=" (l : REAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function ">"  (l : REAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "<"  (l : REAL; r : UNRESOLVED_ufixed) return STD_ULOGIC;

  function maximum (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function maximum (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function minimum (l : UNRESOLVED_ufixed; r : REAL) return UNRESOLVED_ufixed;
  function minimum (l : REAL; r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;

  ----------------------------------------------------------------------------
  -- Comparisons with INTEGER for sfixed
  ----------------------------------------------------------------------------

  function "="  (l : UNRESOLVED_sfixed; r : INTEGER) return BOOLEAN;
  function "/=" (l : UNRESOLVED_sfixed; r : INTEGER) return BOOLEAN;
  function ">=" (l : UNRESOLVED_sfixed; r : INTEGER) return BOOLEAN;
  function "<=" (l : UNRESOLVED_sfixed; r : INTEGER) return BOOLEAN;
  function ">"  (l : UNRESOLVED_sfixed; r : INTEGER) return BOOLEAN;
  function "<"  (l : UNRESOLVED_sfixed; r : INTEGER) return BOOLEAN;

  function "="  (l : INTEGER; r : UNRESOLVED_sfixed) return BOOLEAN;
  function "/=" (l : INTEGER; r : UNRESOLVED_sfixed) return BOOLEAN;
  function ">=" (l : INTEGER; r : UNRESOLVED_sfixed) return BOOLEAN;
  function "<=" (l : INTEGER; r : UNRESOLVED_sfixed) return BOOLEAN;
  function ">"  (l : INTEGER; r : UNRESOLVED_sfixed) return BOOLEAN;
  function "<"  (l : INTEGER; r : UNRESOLVED_sfixed) return BOOLEAN;

  function "="  (l : UNRESOLVED_sfixed; r : INTEGER) return STD_ULOGIC;
  function "/=" (l : UNRESOLVED_sfixed; r : INTEGER) return STD_ULOGIC;
  function ">=" (l : UNRESOLVED_sfixed; r : INTEGER) return STD_ULOGIC;
  function "<=" (l : UNRESOLVED_sfixed; r : INTEGER) return STD_ULOGIC;
  function ">"  (l : UNRESOLVED_sfixed; r : INTEGER) return STD_ULOGIC;
  function "<"  (l : UNRESOLVED_sfixed; r : INTEGER) return STD_ULOGIC;

  function "="  (l : INTEGER; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "/=" (l : INTEGER; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function ">=" (l : INTEGER; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "<=" (l : INTEGER; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function ">"  (l : INTEGER; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "<"  (l : INTEGER; r : UNRESOLVED_sfixed) return STD_ULOGIC;

  function maximum (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function maximum (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function minimum (l : UNRESOLVED_sfixed; r : INTEGER) return UNRESOLVED_sfixed;
  function minimum (l : INTEGER; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  ----------------------------------------------------------------------------
  -- Comparisons with REAL for sfixed
  ----------------------------------------------------------------------------

  function "="  (l : UNRESOLVED_sfixed; r : REAL) return BOOLEAN;
  function "/=" (l : UNRESOLVED_sfixed; r : REAL) return BOOLEAN;
  function ">=" (l : UNRESOLVED_sfixed; r : REAL) return BOOLEAN;
  function "<=" (l : UNRESOLVED_sfixed; r : REAL) return BOOLEAN;
  function ">"  (l : UNRESOLVED_sfixed; r : REAL) return BOOLEAN;
  function "<"  (l : UNRESOLVED_sfixed; r : REAL) return BOOLEAN;

  function "="  (l : REAL; r : UNRESOLVED_sfixed) return BOOLEAN;
  function "/=" (l : REAL; r : UNRESOLVED_sfixed) return BOOLEAN;
  function ">=" (l : REAL; r : UNRESOLVED_sfixed) return BOOLEAN;
  function "<=" (l : REAL; r : UNRESOLVED_sfixed) return BOOLEAN;
  function ">"  (l : REAL; r : UNRESOLVED_sfixed) return BOOLEAN;
  function "<"  (l : REAL; r : UNRESOLVED_sfixed) return BOOLEAN;

  function "="  (l : UNRESOLVED_sfixed; r : REAL) return STD_ULOGIC;
  function "/=" (l : UNRESOLVED_sfixed; r : REAL) return STD_ULOGIC;
  function ">=" (l : UNRESOLVED_sfixed; r : REAL) return STD_ULOGIC;
  function "<=" (l : UNRESOLVED_sfixed; r : REAL) return STD_ULOGIC;
  function ">"  (l : UNRESOLVED_sfixed; r : REAL) return STD_ULOGIC;
  function "<"  (l : UNRESOLVED_sfixed; r : REAL) return STD_ULOGIC;

  function "="  (l : REAL; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "/=" (l : REAL; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function ">=" (l : REAL; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "<=" (l : REAL; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function ">"  (l : REAL; r : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "<"  (l : REAL; r : UNRESOLVED_sfixed) return STD_ULOGIC;

  function maximum (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function maximum (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function minimum (l : UNRESOLVED_sfixed; r : REAL) return UNRESOLVED_sfixed;
  function minimum (l : REAL; r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  --===========================================================================
  -- Shift and Rotate Functions.
  --===========================================================================

  function "sll" (ARG : UNRESOLVED_ufixed; COUNT : INTEGER)
    return UNRESOLVED_ufixed;
  function "srl" (ARG : UNRESOLVED_ufixed; COUNT : INTEGER)
    return UNRESOLVED_ufixed;
  function "rol" (ARG : UNRESOLVED_ufixed; COUNT : INTEGER)
    return UNRESOLVED_ufixed;
  function "ror" (ARG : UNRESOLVED_ufixed; COUNT : INTEGER)
    return UNRESOLVED_ufixed;
  function "sla" (ARG : UNRESOLVED_ufixed; COUNT : INTEGER)
    return UNRESOLVED_ufixed;
  function "sra" (ARG : UNRESOLVED_ufixed; COUNT : INTEGER)
    return UNRESOLVED_ufixed;
  function "sll" (ARG : UNRESOLVED_sfixed; COUNT : INTEGER)
    return UNRESOLVED_sfixed;
  function "srl" (ARG : UNRESOLVED_sfixed; COUNT : INTEGER)
    return UNRESOLVED_sfixed;
  function "rol" (ARG : UNRESOLVED_sfixed; COUNT : INTEGER)
    return UNRESOLVED_sfixed;
  function "ror" (ARG : UNRESOLVED_sfixed; COUNT : INTEGER)
    return UNRESOLVED_sfixed;
  function "sla" (ARG : UNRESOLVED_sfixed; COUNT : INTEGER)
    return UNRESOLVED_sfixed;
  function "sra" (ARG : UNRESOLVED_sfixed; COUNT : INTEGER)
    return UNRESOLVED_sfixed;
  function SHIFT_LEFT  (ARG : UNRESOLVED_ufixed; COUNT : NATURAL)
    return UNRESOLVED_ufixed;
  function SHIFT_RIGHT (ARG : UNRESOLVED_ufixed; COUNT : NATURAL)
    return UNRESOLVED_ufixed;
  function SHIFT_LEFT  (ARG : UNRESOLVED_sfixed; COUNT : NATURAL)
    return UNRESOLVED_sfixed;
  function SHIFT_RIGHT (ARG : UNRESOLVED_sfixed; COUNT : NATURAL)
    return UNRESOLVED_sfixed;

  ----------------------------------------------------------------------------
  -- Logical functions
  ----------------------------------------------------------------------------

  function "not"  (l : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "and"  (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "or"   (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "nand" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "nor"  (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "xor"  (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "xnor" (l, r : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function "not"  (l : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "and"  (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "or"   (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "nand" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "nor"  (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "xor"  (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function "xnor" (l, r : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  -- Vector and std_ulogic functions, same as functions in numeric_std
  function "and"  (l : STD_ULOGIC; r : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  function "and"  (l : UNRESOLVED_ufixed; r : STD_ULOGIC)
    return UNRESOLVED_ufixed;
  function "or"   (l : STD_ULOGIC; r : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  function "or"   (l : UNRESOLVED_ufixed; r : STD_ULOGIC)
    return UNRESOLVED_ufixed;
  function "nand" (l : STD_ULOGIC; r : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  function "nand" (l : UNRESOLVED_ufixed; r : STD_ULOGIC)
    return UNRESOLVED_ufixed;
  function "nor"  (l : STD_ULOGIC; r : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  function "nor"  (l : UNRESOLVED_ufixed; r : STD_ULOGIC)
    return UNRESOLVED_ufixed;
  function "xor"  (l : STD_ULOGIC; r : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  function "xor"  (l : UNRESOLVED_ufixed; r : STD_ULOGIC)
    return UNRESOLVED_ufixed;
  function "xnor" (l : STD_ULOGIC; r : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  function "xnor" (l : UNRESOLVED_ufixed; r : STD_ULOGIC)
    return UNRESOLVED_ufixed;
  function "and"  (l : STD_ULOGIC; r : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  function "and"  (l : UNRESOLVED_sfixed; r : STD_ULOGIC)
    return UNRESOLVED_sfixed;
  function "or"   (l : STD_ULOGIC; r : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  function "or"   (l : UNRESOLVED_sfixed; r : STD_ULOGIC)
    return UNRESOLVED_sfixed;
  function "nand" (l : STD_ULOGIC; r : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  function "nand" (l : UNRESOLVED_sfixed; r : STD_ULOGIC)
    return UNRESOLVED_sfixed;
  function "nor"  (l : STD_ULOGIC; r : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  function "nor"  (l : UNRESOLVED_sfixed; r : STD_ULOGIC)
    return UNRESOLVED_sfixed;
  function "xor"  (l : STD_ULOGIC; r : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  function "xor"  (l : UNRESOLVED_sfixed; r : STD_ULOGIC)
    return UNRESOLVED_sfixed;
  function "xnor" (l : STD_ULOGIC; r : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  function "xnor" (l : UNRESOLVED_sfixed; r : STD_ULOGIC)
    return UNRESOLVED_sfixed;

  -- Reduction operators, same as numeric_std functions
  function "and"  (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "nand" (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "or"   (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "nor"  (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "xor"  (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "xnor" (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  function "and"  (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "nand" (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "or"   (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "nor"  (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "xor"  (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  function "xnor" (l : UNRESOLVED_sfixed) return STD_ULOGIC;

  --function reduce_and_ufixed (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  --function reduce_nand_ufixed (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  --function reduce_or_ufixed (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  --function reduce_nor_ufixed (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  --function reduce_xor_ufixed (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  --function reduce_xnor_ufixed (l : UNRESOLVED_ufixed) return STD_ULOGIC;
  
  --function reduce_and_sfixed (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  --function reduce_nand_sfixed (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  --function reduce_or_sfixed (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  --function reduce_nor_sfixed (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  --function reduce_xor_sfixed (l : UNRESOLVED_sfixed) return STD_ULOGIC;
  --function reduce_xnor_sfixed (l : UNRESOLVED_sfixed) return STD_ULOGIC;


  -- returns arg'low-1 if not found
  function find_leftmost (arg : UNRESOLVED_ufixed; y : STD_ULOGIC) return INTEGER;
  function find_leftmost (arg : UNRESOLVED_sfixed; y : STD_ULOGIC) return INTEGER;

  -- returns arg'high+1 if not found
  function find_rightmost (arg : UNRESOLVED_ufixed; y : STD_ULOGIC) return INTEGER;
  function find_rightmost (arg : UNRESOLVED_sfixed; y : STD_ULOGIC) return INTEGER;

  --===========================================================================
  -- RESIZE Functions
  --===========================================================================
  function resize (
    arg                     : UNRESOLVED_ufixed;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_ufixed;

  function resize (
    arg                     : UNRESOLVED_ufixed;
    size_res                : UNRESOLVED_ufixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_ufixed;

  function resize (
    arg                     : UNRESOLVED_sfixed;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_sfixed;

  function resize (
    arg                     : UNRESOLVED_sfixed;
    size_res                : UNRESOLVED_sfixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_sfixed;

  --===========================================================================
  -- Conversion Functions
  --===========================================================================
  function to_ufixed (
    arg                     : NATURAL;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER                   := 0;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_ufixed;

  function to_ufixed (
    arg                     : NATURAL;
    size_res                : UNRESOLVED_ufixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_ufixed;

  function to_ufixed (
    arg                     : REAL;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style;
    constant guard_bits     : NATURAL                   := fixed_guard_bits)
    return UNRESOLVED_ufixed;

  function to_ufixed (
    arg                     : REAL;
    size_res                : UNRESOLVED_ufixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style;
    constant guard_bits     : NATURAL                   := fixed_guard_bits)
    return UNRESOLVED_ufixed;

  function to_ufixed (
    arg                     : UNRESOLVED_UNSIGNED;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER                   := 0;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_ufixed;

  function to_ufixed (
    arg                     : UNRESOLVED_UNSIGNED;
    size_res                : UNRESOLVED_ufixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_ufixed;

  function to_ufixed (
    arg : UNRESOLVED_UNSIGNED)
    return UNRESOLVED_ufixed;

  function to_unsigned (
    arg                     : UNRESOLVED_ufixed;
    constant size           : NATURAL;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_UNSIGNED;

  function to_unsigned (
    arg                     : UNRESOLVED_ufixed;
    size_res                : UNRESOLVED_UNSIGNED;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_UNSIGNED;

  function to_real (
    arg : UNRESOLVED_ufixed)
    return REAL;

  function to_integer (
    arg                     : UNRESOLVED_ufixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return NATURAL;

  function to_sfixed (
    arg                     : INTEGER;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER                   := 0;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg                     : INTEGER;
    size_res                : UNRESOLVED_sfixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg                     : REAL;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style;
    constant guard_bits     : NATURAL                   := fixed_guard_bits)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg                     : REAL;
    size_res                : UNRESOLVED_sfixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style;
    constant guard_bits     : NATURAL                   := fixed_guard_bits)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg                     : UNRESOLVED_SIGNED;
    constant left_index     : INTEGER;
    constant right_index    : INTEGER                   := 0;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg                     : UNRESOLVED_SIGNED;
    size_res                : UNRESOLVED_sfixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg : UNRESOLVED_SIGNED)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg : UNRESOLVED_ufixed)
    return UNRESOLVED_sfixed;

  function to_signed (
    arg                     : UNRESOLVED_sfixed;
    constant size           : NATURAL;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_SIGNED;

  function to_signed (
    arg                     : UNRESOLVED_sfixed;
    size_res                : UNRESOLVED_SIGNED;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return UNRESOLVED_SIGNED;

  function to_real (
    arg : UNRESOLVED_sfixed)
    return REAL;

  function to_integer (
    arg                     : UNRESOLVED_sfixed;
    constant overflow_style : fixed_overflow_style_type := fixed_overflow_style;
    constant round_style    : fixed_round_style_type    := fixed_round_style)
    return INTEGER;

  function ufixed_high (left_index, right_index   : INTEGER;
                        operation                 : CHARACTER := 'X';
                        left_index2, right_index2 : INTEGER   := 0)
    return INTEGER;

  function ufixed_low (left_index, right_index   : INTEGER;
                       operation                 : CHARACTER := 'X';
                       left_index2, right_index2 : INTEGER   := 0)
    return INTEGER;

  function sfixed_high (left_index, right_index   : INTEGER;
                        operation                 : CHARACTER := 'X';
                        left_index2, right_index2 : INTEGER   := 0)
    return INTEGER;

  function sfixed_low (left_index, right_index   : INTEGER;
                       operation                 : CHARACTER := 'X';
                       left_index2, right_index2 : INTEGER   := 0)
    return INTEGER;

  function ufixed_high (size_res  : UNRESOLVED_ufixed;
                        operation : CHARACTER := 'X';
                        size_res2 : UNRESOLVED_ufixed)
    return INTEGER;

  function ufixed_low (size_res  : UNRESOLVED_ufixed;
                       operation : CHARACTER := 'X';
                       size_res2 : UNRESOLVED_ufixed)
    return INTEGER;

  function sfixed_high (size_res  : UNRESOLVED_sfixed;
                        operation : CHARACTER := 'X';
                        size_res2 : UNRESOLVED_sfixed)
    return INTEGER;

  function sfixed_low (size_res  : UNRESOLVED_sfixed;
                       operation : CHARACTER := 'X';
                       size_res2 : UNRESOLVED_sfixed)
    return INTEGER;

  function saturate (
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_ufixed;

  function saturate (
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_sfixed;

  function saturate (
    size_res : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;

  function saturate (
    size_res : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;

  --===========================================================================
  -- Translation Functions
  --===========================================================================

  function to_01 (
    s             : UNRESOLVED_ufixed;
    constant XMAP : STD_ULOGIC := '0')
    return UNRESOLVED_ufixed;

  function to_01 (
    s             : UNRESOLVED_sfixed;
    constant XMAP : STD_ULOGIC := '0')
    return UNRESOLVED_sfixed;

  function Is_X    (arg : UNRESOLVED_ufixed) return BOOLEAN;
  function Is_X    (arg : UNRESOLVED_sfixed) return BOOLEAN;
  function to_X01  (arg : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function to_X01  (arg : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function to_X01Z (arg : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function to_X01Z (arg : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;
  function to_UX01 (arg : UNRESOLVED_ufixed) return UNRESOLVED_ufixed;
  function to_UX01 (arg : UNRESOLVED_sfixed) return UNRESOLVED_sfixed;

  function to_slv (
    arg : UNRESOLVED_ufixed)
    return STD_LOGIC_VECTOR;
  alias to_StdLogicVector is to_slv [UNRESOLVED_ufixed return STD_LOGIC_VECTOR];
  alias to_Std_Logic_Vector is to_slv [UNRESOLVED_ufixed return STD_LOGIC_VECTOR];

  function to_slv (
    arg : UNRESOLVED_sfixed)
    return STD_LOGIC_VECTOR;
  alias to_StdLogicVector is to_slv [UNRESOLVED_sfixed return STD_LOGIC_VECTOR];
  alias to_Std_Logic_Vector is to_slv [UNRESOLVED_sfixed return STD_LOGIC_VECTOR];

  function to_sulv (
    arg : UNRESOLVED_ufixed)
    return STD_ULOGIC_VECTOR;
  alias to_StdULogicVector is to_sulv [UNRESOLVED_ufixed return STD_ULOGIC_VECTOR];
  alias to_Std_ULogic_Vector is to_sulv [UNRESOLVED_ufixed return STD_ULOGIC_VECTOR];

  function to_sulv (
    arg : UNRESOLVED_sfixed)
    return STD_ULOGIC_VECTOR;
  alias to_StdULogicVector is to_sulv [UNRESOLVED_sfixed return STD_ULOGIC_VECTOR];
  alias to_Std_ULogic_Vector is to_sulv [UNRESOLVED_sfixed return STD_ULOGIC_VECTOR];

  function to_ufixed (
    arg                  : STD_ULOGIC_VECTOR;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_ufixed;

  function to_ufixed (
    arg      : STD_ULOGIC_VECTOR;
    size_res : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;

  function to_sfixed (
    arg                  : STD_ULOGIC_VECTOR;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_sfixed;

  function to_sfixed (
    arg      : STD_ULOGIC_VECTOR;
    size_res : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;

  function to_UFix (
    arg      : STD_ULOGIC_VECTOR;
    width    : NATURAL;
    fraction : NATURAL)
    return UNRESOLVED_ufixed;

  function to_SFix (
    arg      : STD_ULOGIC_VECTOR;
    width    : NATURAL;
    fraction : NATURAL)
    return UNRESOLVED_sfixed;

  function UFix_high (width, fraction   : NATURAL;
                      operation         : CHARACTER := 'X';
                      width2, fraction2 : NATURAL   := 0)
    return INTEGER;

  function UFix_low (width, fraction   : NATURAL;
                     operation         : CHARACTER := 'X';
                     width2, fraction2 : NATURAL   := 0)
    return INTEGER;

  function SFix_high (width, fraction   : NATURAL;
                      operation         : CHARACTER := 'X';
                      width2, fraction2 : NATURAL   := 0)
    return INTEGER;

  function SFix_low (width, fraction   : NATURAL;
                     operation         : CHARACTER := 'X';
                     width2, fraction2 : NATURAL   := 0)
    return INTEGER;

  --===========================================================================
  -- string and textio Functions
  --===========================================================================

  procedure WRITE (
    L         : inout LINE;
    VALUE     : in    UNRESOLVED_ufixed;
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure WRITE (
    L         : inout LINE;
    VALUE     : in    UNRESOLVED_sfixed;
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure READ(L     : inout LINE;
                 VALUE : out   UNRESOLVED_ufixed);

  procedure READ(L     : inout LINE;
                 VALUE : out   UNRESOLVED_ufixed;
                 GOOD  : out   BOOLEAN);

  procedure READ(L     : inout LINE;
                 VALUE : out   UNRESOLVED_sfixed);

  procedure READ(L     : inout LINE;
                 VALUE : out   UNRESOLVED_sfixed;
                 GOOD  : out   BOOLEAN);

  alias bwrite is WRITE [LINE, UNRESOLVED_ufixed, SIDE, width];
  alias bwrite is WRITE [LINE, UNRESOLVED_sfixed, SIDE, width];
  alias bread is READ [LINE, UNRESOLVED_ufixed];
  alias bread is READ [LINE, UNRESOLVED_ufixed, BOOLEAN];
  alias bread is READ [LINE, UNRESOLVED_sfixed];
  alias bread is READ [LINE, UNRESOLVED_sfixed, BOOLEAN];
  alias BINARY_WRITE is WRITE [LINE, UNRESOLVED_ufixed, SIDE, width];
  alias BINARY_WRITE is WRITE [LINE, UNRESOLVED_sfixed, SIDE, width];
  alias BINARY_READ is READ [LINE, UNRESOLVED_ufixed, BOOLEAN];
  alias BINARY_READ is READ [LINE, UNRESOLVED_ufixed];
  alias BINARY_READ is READ [LINE, UNRESOLVED_sfixed, BOOLEAN];
  alias BINARY_READ is READ [LINE, UNRESOLVED_sfixed];

  procedure OWRITE (
    L         : inout LINE;
    VALUE     : in    UNRESOLVED_ufixed;
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure OWRITE (
    L         : inout LINE;
    VALUE     : in    UNRESOLVED_sfixed;
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_ufixed);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_ufixed;
                  GOOD  : out   BOOLEAN);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_sfixed);

  procedure OREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_sfixed;
                  GOOD  : out   BOOLEAN);

  alias OCTAL_READ is OREAD [LINE, UNRESOLVED_ufixed, BOOLEAN];
  alias OCTAL_READ is OREAD [LINE, UNRESOLVED_ufixed];
  alias OCTAL_READ is OREAD [LINE, UNRESOLVED_sfixed, BOOLEAN];
  alias OCTAL_READ is OREAD [LINE, UNRESOLVED_sfixed];
  alias OCTAL_WRITE is OWRITE [LINE, UNRESOLVED_ufixed, SIDE, WIDTH];
  alias OCTAL_WRITE is OWRITE [LINE, UNRESOLVED_sfixed, SIDE, WIDTH];

  procedure HWRITE (
    L         : inout LINE;
    VALUE     : in    UNRESOLVED_ufixed;
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure HWRITE (
    L         : inout LINE;
    VALUE     : in    UNRESOLVED_sfixed;
    JUSTIFIED : in    SIDE  := right;
    FIELD     : in    WIDTH := 0);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_ufixed);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_ufixed;
                  GOOD  : out   BOOLEAN);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_sfixed);

  procedure HREAD(L     : inout LINE;
                  VALUE : out   UNRESOLVED_sfixed;
                  GOOD  : out   BOOLEAN);

  alias HEX_READ is HREAD [LINE, UNRESOLVED_ufixed, BOOLEAN];
  alias HEX_READ is HREAD [LINE, UNRESOLVED_sfixed, BOOLEAN];
  alias HEX_READ is HREAD [LINE, UNRESOLVED_ufixed];
  alias HEX_READ is HREAD [LINE, UNRESOLVED_sfixed];
  alias HEX_WRITE is HWRITE [LINE, UNRESOLVED_ufixed, SIDE, WIDTH];
  alias HEX_WRITE is HWRITE [LINE, UNRESOLVED_sfixed, SIDE, WIDTH];

  function TO_STRING (value : UNRESOLVED_ufixed) return STRING;
  alias TO_BSTRING is TO_STRING [UNRESOLVED_ufixed return STRING];
  alias TO_BINARY_STRING is TO_STRING [UNRESOLVED_ufixed return STRING];

  function TO_OSTRING (value : UNRESOLVED_ufixed) return STRING;
  alias TO_OCTAL_STRING is TO_OSTRING [UNRESOLVED_ufixed return STRING];

  function TO_HSTRING (value : UNRESOLVED_ufixed) return STRING;
  alias TO_HEX_STRING is TO_HSTRING [UNRESOLVED_ufixed return STRING];

  function TO_STRING (value : UNRESOLVED_sfixed) return STRING;
  alias TO_BSTRING is TO_STRING [UNRESOLVED_sfixed return STRING];
  alias TO_BINARY_STRING is TO_STRING [UNRESOLVED_sfixed return STRING];

  function TO_OSTRING (value : UNRESOLVED_sfixed) return STRING;
  alias TO_OCTAL_STRING is TO_OSTRING [UNRESOLVED_sfixed return STRING];

  function TO_HSTRING (value : UNRESOLVED_sfixed) return STRING;
  alias TO_HEX_STRING is TO_HSTRING [UNRESOLVED_sfixed return STRING];

  function from_string (
    bstring              : STRING;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_ufixed;
  alias from_bstring is from_string [STRING, INTEGER, INTEGER return UNRESOLVED_ufixed];
  alias from_binary_string is from_string [STRING, INTEGER, INTEGER return UNRESOLVED_ufixed];

  function from_ostring (
    ostring              : STRING;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_ufixed;
  alias from_octal_string is from_ostring [STRING, INTEGER, INTEGER return UNRESOLVED_ufixed];

  function from_hstring (
    hstring              : STRING;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_ufixed;
  alias from_hex_string is from_hstring [STRING, INTEGER, INTEGER return UNRESOLVED_ufixed];

  function from_string (
    bstring              : STRING;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_sfixed;
  alias from_bstring is from_string [STRING, INTEGER, INTEGER return UNRESOLVED_sfixed];
  alias from_binary_string is from_string [STRING, INTEGER, INTEGER return UNRESOLVED_sfixed];

  function from_ostring (
    ostring              : STRING;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_sfixed;
  alias from_octal_string is from_ostring [STRING, INTEGER, INTEGER return UNRESOLVED_sfixed];

  function from_hstring (
    hstring              : STRING;
    constant left_index  : INTEGER;
    constant right_index : INTEGER)
    return UNRESOLVED_sfixed;
  alias from_hex_string is from_hstring [STRING, INTEGER, INTEGER return UNRESOLVED_sfixed];

  function from_string (
    bstring  : STRING;
    size_res : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  alias from_bstring is from_string [STRING, UNRESOLVED_ufixed return UNRESOLVED_ufixed];
  alias from_binary_string is from_string [STRING, UNRESOLVED_ufixed return UNRESOLVED_ufixed];

  function from_ostring (
    ostring  : STRING;
    size_res : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  alias from_octal_string is from_ostring [STRING, UNRESOLVED_ufixed return UNRESOLVED_ufixed];

  function from_hstring (
    hstring  : STRING;
    size_res : UNRESOLVED_ufixed)
    return UNRESOLVED_ufixed;
  alias from_hex_string is from_hstring [STRING, UNRESOLVED_ufixed return UNRESOLVED_ufixed];

  function from_string (
    bstring  : STRING;
    size_res : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  alias from_bstring is from_string [STRING, UNRESOLVED_sfixed return UNRESOLVED_sfixed];
  alias from_binary_string is from_string [STRING, UNRESOLVED_sfixed return UNRESOLVED_sfixed];

  function from_ostring (
    ostring  : STRING;
    size_res : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  alias from_octal_string is from_ostring [STRING, UNRESOLVED_sfixed return UNRESOLVED_sfixed];

  function from_hstring (
    hstring  : STRING;
    size_res : UNRESOLVED_sfixed)
    return UNRESOLVED_sfixed;
  alias from_hex_string is from_hstring [STRING, UNRESOLVED_sfixed return UNRESOLVED_sfixed];

  function from_string (
    bstring : STRING)
    return UNRESOLVED_ufixed;
  alias from_bstring is from_string [STRING return UNRESOLVED_ufixed];
  alias from_binary_string is from_string [STRING return UNRESOLVED_ufixed];

  function from_ostring (
    ostring : STRING)
    return UNRESOLVED_ufixed;
  alias from_octal_string is from_ostring [STRING return UNRESOLVED_ufixed];

  function from_hstring (
    hstring : STRING)
    return UNRESOLVED_ufixed;
  alias from_hex_string is from_hstring [STRING return UNRESOLVED_ufixed];

  function from_string (
    bstring : STRING)
    return UNRESOLVED_sfixed;
  alias from_bstring is from_string [STRING return UNRESOLVED_sfixed];
  alias from_binary_string is from_string [STRING return UNRESOLVED_sfixed];

  function from_ostring (
    ostring : STRING)
    return UNRESOLVED_sfixed;
  alias from_octal_string is from_ostring [STRING return UNRESOLVED_sfixed];

  function from_hstring (
    hstring : STRING)
    return UNRESOLVED_sfixed;
  alias from_hex_string is from_hstring [STRING return UNRESOLVED_sfixed];

end package fixed;

