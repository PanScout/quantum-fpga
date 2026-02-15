library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use work.sfixed36.ALL;
--use IEEE.fixed_pkg.ALL;
--use IEEE.fixed_pkg.ALL;
use work.fixed_pkg.ALL;

-- Import your custom types (csfixed36, cvector, sfixed36, etc.)
use work.qTypes.all;

entity max_real_part_of_cvector is
    port (
        -- Input vector of complex values (high precision)
        -- We'll only look at the 're' field.
        inputVector  : in  cvector;
        
        -- Output: the largest real value found in 'inputVector'.
        largestValue : out sfixed36
    );
end entity max_real_part_of_cvector;

architecture gen of max_real_part_of_cvector is

    -- A local array to hold the "running max" at each position
    type fixedHighVector is array(inputVector'range) of sfixed36;
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
