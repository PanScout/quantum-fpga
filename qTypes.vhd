-- #############################################################################
-- #  << Quantum FPGA Emulator >>                                              #
-- #############################################################################
-- #  File        : qTypes.vhd                                                 #
-- #  Authors      : Kelan Zielinski, Michael Denis, Jasem Alkhashti           #
-- #  Emails       : ksz12@miami.edu, mwd47@miami.edu, jta568@miami.edu        #
-- #  Affiliation : University of Miami - College of Engineering               #
-- #  Created     : 02-07-2025                                                 #
-- #  Revised     : 02-07-2025 - Present                                       #
-- #  Description : data types that will be used throughout the project        #
-- #  Dependencies: [List key dependencies (e.g., libraries, other entities)]  #
-- #  Parameters  : [List key generics/parameters]                             #
-- #  Usage       : [Usage constraints or target applications]                 #
-- #############################################################################
-- #  Copyright (c) 2025 University of Miami. All rights reserved.             #
-- #  Licensed under the [License Name, e.g., MIT License]. See LICENSE file.  #
-- #############################################################################

-- =============================================================================
--                               Revision History
-- =============================================================================
-- [DD-MM-YYYY] [Your Initials]: [Description of changes]
-- =============================================================================

-- =============================================================================
--                              Module Description
-- =============================================================================
-- Defines data types for fixed-point numbers with both low and high precision.
-- Scaling with the number of qubits (nQubits).
-- Defines vectors (cvector, cvectorHigh) and matrices (cmatrix, cmatrixHigh). 
-- Defines conversion functions between low and high precision datatypes.
-- =============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.fixed_pkg.ALL;

-- Package Specification
package qTypes is
    -- Number of qubits
    constant nQubits : integer := 2;
    
    -- Number of basis states = 2^nQubits
    constant numBasisStates : integer := 2 ** nQubits;
    
    -- Fixed-point subtype with lower precision
    subtype fixed is sfixed(14 downto -10); 
    
    -- Fixed-point subtype with higher precision
    subtype fixedHigh is sfixed(50 downto -64); 
    
    -- Complex fixed-point record for lower precision
    type cfixed is record
        re : fixed;
        im : fixed;
    end record;
    
    -- Complex fixed-point record for higher precision
    type cfixedHigh is record
        re : fixedHigh;
        im : fixedHigh;
    end record;
    
    -- Vector of complex fixed, length numBasisStates (lower precision)
    type cvector is array (0 to numBasisStates - 1) of cfixed;
    
    -- Vector of complex fixed, length numBasisStates (higher precision)
    type cvectorHigh is array (0 to numBasisStates - 1) of cfixedHigh;
    
    -- Matrix of cvector, dimension numBasisStates x numBasisStates (lower precision)
    type cmatrix is array (0 to numBasisStates - 1) of cvector;
    
    -- Matrix of cvectorHigh, dimension numBasisStates x numBasisStates (higher precision)
    type cmatrixHigh is array (0 to numBasisStates - 1) of cvectorHigh;
    
    ----------------------------------------------------------------------------
    -- Conversion Function Declarations
    ----------------------------------------------------------------------------
    
    -- Conversion for a single complex fixed-point value:
    function toCfixedHigh(x : cfixed) return cfixedHigh;
    function toCfixed(x : cfixedHigh) return cfixed;
    
    -- Conversion for a vector (calls the single element conversion)
    function toCvectorHigh(x : cvector) return cvectorHigh;
    function toCvector(x : cvectorHigh) return cvector;
    
    -- Conversion for a matrix (calls the vector conversion)
    function toCmatrixHigh(x : cmatrix) return cmatrixHigh;
    function toCmatrix(x : cmatrixHigh) return cmatrix;
    
end package qTypes;

-- Package Body
package body qTypes is

    ----------------------------------------------------------------------------
    -- Conversion for a single complex fixed-point value:
    ----------------------------------------------------------------------------
    
    -- Lower precision -> Higher precision
    function toCfixedHigh(x : cfixed) return cfixedHigh is
        variable ret : cfixedHigh;
    begin
        ret.re := resize(x.re, fixedHigh'high, fixedHigh'low);
        ret.im := resize(x.im, fixedHigh'high, fixedHigh'low);
        return ret;
    end function;
    
    -- Higher precision -> Lower precision
    function toCfixed(x : cfixedHigh) return cfixed is
        variable ret : cfixed;
    begin
        ret.re := resize(x.re, fixed'high, fixed'low);
        ret.im := resize(x.im, fixed'high, fixed'low);
        return ret;
    end function;
    
    ----------------------------------------------------------------------------
    -- Conversion for a vector:
    ----------------------------------------------------------------------------
    
    -- Lower precision vector -> Higher precision vector
    function toCvectorHigh(x : cvector) return cvectorHigh is
        variable ret : cvectorHigh;
    begin
        for i in x'range loop
            ret(i) := toCfixedHigh(x(i));
        end loop;
        return ret;
    end function;
    
    -- Higher precision vector -> Lower precision vector
    function toCvector(x : cvectorHigh) return cvector is
        variable ret : cvector;
    begin
        for i in x'range loop
            ret(i) := toCfixed(x(i));
        end loop;
        return ret;
    end function;
    
    ----------------------------------------------------------------------------
    -- Conversion for a matrix:
    ----------------------------------------------------------------------------
    
    -- Lower precision matrix -> Higher precision matrix
    function toCmatrixHigh(x : cmatrix) return cmatrixHigh is
        variable ret : cmatrixHigh;
    begin
        for i in x'range loop
            ret(i) := toCvectorHigh(x(i));
        end loop;
        return ret;
    end function;
    
    -- Higher precision matrix -> Lower precision matrix
    function toCmatrix(x : cmatrixHigh) return cmatrix is
        variable ret : cmatrix;
    begin
        for i in x'range loop
            ret(i) := toCvector(x(i));
        end loop;
        return ret;
    end function;
    
end package body qTypes;

