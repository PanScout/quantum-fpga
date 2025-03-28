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
-- Defines data types for fixed64-point numbers with both low and high precision.
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
    
    -- Number of basis states = 2^nQubits
    constant dimension : integer := 2 ** numQubits;
    
    -- fixed64-point subtype with higher precision
    subtype fixed64 is sfixed(14 downto -12); 
    
    -- Complex fixed64-point record for lower precision
    type cfixed64 is record
        re : fixed64;
        im : fixed64;
    end record;
    
    -- Vector of complex fixed64, length dimension (lower precision)
    type cvector is array (0 to dimension - 1) of cfixed64;
    
    -- Matrix of cvector, dimension dimension x dimension (lower precision)
    type cmatrix is array (0 to dimension - 1) of cvector;
    
    ----------------------------------------------------------------------------
    -- Conversion Function Declarations
    ----------------------------------------------------------------------------

    
end package qTypes;

-- Package Body
package body qTypes is

    
end package body qTypes;

