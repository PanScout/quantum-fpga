-- #############################################################################
-- #  << Quantum FPGA Emulator >>                                              #
-- #############################################################################
-- #  File        : qTypes.vhd                                                 #
-- #  Authors     : Kelan Zielinski, Michael Denis, Jasem Alkhashti            #
-- #  Emails      : ksz12@miami.edu, mwd47@miami.edu, jta568@miami.edu         #
-- #  Affiliation : University of Miami - College of Engineering               #
-- #  Created     : 02-07-2025                                                 #
-- #  Revised     : 02-07-2025 - Present                                       #
-- #  Description : data types that will be used throughout the project        #
-- #  Dependencies: [List key dependencies (e.g., libraries, other entities)]  #
-- #  Parameters  : [List key generics/parameters]                             #
-- #  Usage       : [Usage constraints or target applications]                 #
-- #############################################################################
-- #  Copyright (c) 2025 Khizroev's Greatest Minions. All rights reserved.     #
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
-- Defines vectors (cvector, cvector) and matrices (cmatrix, cmatrix). 
-- Defines conversion functions between low and high precision datatypes.
-- =============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

-- Package Specification
package qTypes is 
    -- Number of qubits
    constant numQubits : integer := 1;
	 
    constant numComplexNumbersInMatrix : integer  :=  2**numQubits * 2**numQubits;
    constant numComplexNumbersinVector : integer  :=  2**numQubits;
    
    -- Number of basis states = 2^nQubits
    constant dimension : integer := 2 ** numQubits;
    
    -- sfixed36-point subtype with higher precision
    --subtype sfixed36 is sfixed(14 downto -21); 
	 subtype sfixed36 is sfixed(14 downto -21); 

    subtype sfixed64 is sfixed(19 downto -44);
    
    -- Complex sfixed36-point record for lower precision
    type csfixed36 is record
        re : sfixed36;
        im : sfixed36;
    end record;
    
    -- Vector of complex sfixed36, length dimension (lower precision)
    type cvector is array (0 to dimension - 1) of csfixed36;
    
    -- Matrix of cvector, dimension dimension x dimension (lower precision)
    type cmatrix is array (0 to dimension - 1) of cvector;
    type psi_matrix is array (0 to 29) of cvector;
    
    ----------------------------------------------------------------------------
    -- Conversion Function Declarations
    ----------------------------------------------------------------------------
    -- Convert 36-bit sfixed36 to 64-bit sfixed64
    function to_64bit(f : sfixed36) return sfixed64;

    -- Convert 64-bit sfixed64 back to 36-bit sfixed36
    function from_64bit(f : sfixed64) return sfixed36;
    
end package qTypes;

-- Package Body
package body qTypes is
    -- Function to convert 36-bit sfixed36 to 64-bit sfixed64
    function to_64bit(f : sfixed36) return sfixed64 is
    begin
        return resize(f, sfixed64'high, sfixed64'low);
    end function to_64bit;
    
    -- Function to convert 64-bit sfixed64 back to 36-bit sfixed36
    function from_64bit(f : sfixed64) return sfixed36 is
    begin
        return resize(f, sfixed36'high, sfixed36'low);
    end function from_64bit;

end package body qTypes;

