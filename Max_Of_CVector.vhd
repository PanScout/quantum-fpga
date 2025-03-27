library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.fixed64.ALL;
--use IEEE.fixed_pkg.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

-- Import your custom types (cfixed64, cvector, fixed64, etc.)
use work.qTypes.all;

entity Max_Of_CVector is
    port (
        -- Input vector of complex values (high precision)
        -- We'll only look at the 're' field.
        inputVector  : in  cvector;
        
        -- Output: the largest real value found in 'inputVector'.
        largestValue : out fixed64
    );
end entity Max_Of_CVector;

architecture gen of Max_Of_CVector is

    -- A local array to hold the "running max" at each position
    type fixedHighVector is array(inputVector'range) of fixed64;
    signal chainMax : fixedHighVector;
    
begin

    ----------------------------------------------------------------------------
    -- 1) Initialize for the first element in the vector
    ----------------------------------------------------------------------------
    init_chain: chainMax(inputVector'left) <= inputVector(inputVector'left).re;

    ----------------------------------------------------------------------------
    -- 2) Generate comparators in a linear chain
    ----------------------------------------------------------------------------
    cmp_gen: for i in (inputVector'left+1) to inputVector'right generate
        with inputVector(i).re > chainMax(i-1) select
            chainMax(i) <= inputVector(i).re when true,
                          chainMax(i-1)      when false;
    end generate cmp_gen;

    ----------------------------------------------------------------------------
    -- 3) Output the final maximum value
    ----------------------------------------------------------------------------
    largestValue <= chainMax(inputVector'right);

end architecture gen;
