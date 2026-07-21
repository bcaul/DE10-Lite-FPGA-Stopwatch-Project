-- EEEN11102 Digital Electronics
-- The University of Manchester
-- Assignment 5.2 - synchronous clr added

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_counter is
    port (
        clk  : in  std_logic;
        run  : in  std_logic;
        clr  : in  std_logic;                     -- synchronous clear (active high)
        d0   : out std_logic_vector(3 downto 0);  -- centiseconds units
        d1   : out std_logic_vector(3 downto 0);  -- centiseconds tens
        d2   : out std_logic_vector(3 downto 0);  -- seconds units
        d3   : out std_logic_vector(3 downto 0);  -- seconds tens
        d4   : out std_logic_vector(3 downto 0);  -- minutes units
        d5   : out std_logic_vector(3 downto 0)   -- minutes tens
    );
end entity bcd_counter;

architecture rtl of bcd_counter is

    signal r0, r1, r2, r3, r4, r5 : unsigned(3 downto 0) := "0000";
    signal incr0, incr1, incr2, incr3, incr4, incr5 : std_logic;

begin

    incr0 <= run;
    incr1 <= incr0 when r0 = 9 else '0';
    incr2 <= incr1 when r1 = 9 else '0';
    incr3 <= incr2 when r2 = 9 else '0';
    incr4 <= incr3 when r3 = 5 else '0'; -- seconds roll over at 60
    incr5 <= incr4 when r4 = 9 else '0';

    process(clk)
    begin
        if rising_edge(clk) then
            if clr = '1' then
                -- synchronous clear takes priority over run/increment logic
                r0 <= "0000";
                r1 <= "0000";
                r2 <= "0000";
                r3 <= "0000";
                r4 <= "0000";
                r5 <= "0000";
            else
                if incr0 = '1' then r0 <= r0 + 1; end if;
                if incr1 = '1' then r0 <= "0000"; r1 <= r1 + 1; end if;
                if incr2 = '1' then r1 <= "0000"; r2 <= r2 + 1; end if;
                if incr3 = '1' then r2 <= "0000"; r3 <= r3 + 1; end if;
                if incr4 = '1' then r3 <= "0000"; r4 <= r4 + 1; end if;
                if incr5 = '1' then r4 <= "0000"; r5 <= r5 + 1; end if;
                if incr5 = '1' and r5 = 9 then r5 <= "0000"; end if;
            end if;
        end if;
    end process;

    d0 <= std_logic_vector(r0);
    d1 <= std_logic_vector(r1);
    d2 <= std_logic_vector(r2);
    d3 <= std_logic_vector(r3);
    d4 <= std_logic_vector(r4);
    d5 <= std_logic_vector(r5);

end architecture rtl;
