library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.qTypes.ALL;
use work.fixed_pkg.ALL;

entity tb_Calculate_Norm_and_Compare is
end tb_Calculate_Norm_and_Compare;

architecture Behavioral of tb_Calculate_Norm_and_Compare is

    component Calculate_Norm_And_Compare is
        port (
            A               : in  cmatrixHigh;
            isBelow         : out std_logic;
            InfinityNormOut : out cfixedHigh
        );
    end component;

    signal A : cmatrixHigh;
    signal isBelow : std_logic;
    signal InfinityNormOut : cfixedHigh;

begin

    uut: Calculate_Norm_And_Compare
        port map (
            A => A,
            isBelow => isBelow,
            InfinityNormOut => InfinityNormOut
        );

    process
        -- Helper function to convert fixed point to real
        function to_real_fx(fx : cfixedHigh) return real is
        begin
            return to_real(fx.re);
        end function;

    begin
        -- Initialize all elements to 0
        for i in A'range loop               -- Loop through rows
            for j in A(i)'range loop         -- Loop through columns
                A(i)(j).re <= to_sfixed(0.0, A(i)(j).re);
                A(i)(j).im <= to_sfixed(0.0, A(i)(j).im);
            end loop;
        end loop;
        
        -- Set diagonal elements to 1.0+0i
        for k in A'range loop
            A(k)(k).re <= to_sfixed(1.0, A(k)(k).re);
            A(k)(k).im <= to_sfixed(0.0, A(k)(k).im);
        end loop;

        wait for 10 ns;

        -- Verify outputs
        assert to_real_fx(InfinityNormOut) = 1.0
            report "Error: Infinity norm should be 1.0. Got " 
                   & real'image(to_real_fx(InfinityNormOut))
            severity error;

        assert to_real(InfinityNormOut.im) = 0.0
            report "Error: Imaginary part should be 0.0"
            severity error;

        if isBelow = '1' then
            report "Test PASSED: THETA > infinity norm (1.0)";
        else
            report "Test FAILED: THETA <= infinity norm (1.0)";
        end if;

        wait;
    end process;

end Behavioral;
