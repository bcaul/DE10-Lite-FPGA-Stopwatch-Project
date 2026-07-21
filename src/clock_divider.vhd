-- EEEN11102 Digital Electronics
-- The University of Manchester

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity clock_divider is
    port (
        clk_50 : in  std_logic;
        clk    : out std_logic
    );
end entity clock_divider;
 
architecture rtl of clock_divider is
    constant MAX_COUNT : integer := 249999;
    signal   count     : integer range 0 to MAX_COUNT := 0;
    signal   clock     : std_logic := '0';
begin
    process(clk_50)
    begin
        if rising_edge(clk_50) then
            if count = MAX_COUNT then
                count <= 0;
                clock  <= not clock;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
     clk <= clock;
end architecture rtl;
