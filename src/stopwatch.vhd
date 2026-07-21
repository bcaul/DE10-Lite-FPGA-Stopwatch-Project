-- EEEN11102 Digital Electronics
-- The University of Manchester
-- Assignment 5.3 - top level with FSM controller + decimal point bonus (MM.SS.CC)

library ieee;
use ieee.std_logic_1164.all;

entity stopwatch is
    port (
        CLOCK_50 : in  std_logic;
        KEY0     : in  std_logic; -- START button (active low)
        KEY1     : in  std_logic; -- STOP button  (active low)
        KEY2     : in  std_logic; -- RESET button (active low)  (mapped to SW0, PIN_C10)
        HEX0     : out std_logic_vector(7 downto 0); -- bit7 = DP
        HEX1     : out std_logic_vector(7 downto 0);
        HEX2     : out std_logic_vector(7 downto 0); -- bit7 = DP (lit, seconds separator)
        HEX3     : out std_logic_vector(7 downto 0);
        HEX4     : out std_logic_vector(7 downto 0); -- bit7 = DP (lit, minutes separator)
        HEX5     : out std_logic_vector(7 downto 0)
    );
end entity stopwatch;
architecture rtl of stopwatch is

    -- Internal signals
    signal clk, run, clr          : std_logic;
    signal d0, d1, d2, d3, d4, d5 : std_logic_vector(3 downto 0);
    signal seg0, seg1, seg2, seg3, seg4, seg5 : std_logic_vector(6 downto 0);

begin

    -- Clock divider: 50 MHz -> 100 Hz tick
    u_div : entity work.clock_divider
        port map ( clk_50 => CLOCK_50, clk => clk );

    -- FSM controller: START/STOP/RESET buttons -> run/clr for the counter
    u_fsm : entity work.fsm_control
        port map (
            clk   => clk,
            START => KEY0,
            STOP  => KEY1,
            RESET => KEY2,
            run   => run,
            clr   => clr
        );

    -- BCD counter
    u_cnt : entity work.bcd_counter
        port map (
            clk => clk, run => run, clr => clr,
            d0  => d0, d1 => d1, d2 => d2,
            d3  => d3, d4 => d4, d5 => d5
        );

    -- Six encoder instances, one per display digit
    enc0 : entity work.encoder port map ( num => d0, seg => seg0 );
    enc1 : entity work.encoder port map ( num => d1, seg => seg1 );
    enc2 : entity work.encoder port map ( num => d2, seg => seg2 );
    enc3 : entity work.encoder port map ( num => d3, seg => seg3 );
    enc4 : entity work.encoder port map ( num => d4, seg => seg4 );
    enc5 : entity work.encoder port map ( num => d5, seg => seg5 );

    -- Drive the 7 segments of each digit; bit 7 is the decimal point
    -- ('0' = DP on, '1' = DP off). DP lit between minutes|seconds (HEX4)
    -- and between seconds|centiseconds (HEX2) to show 00.00.00
    HEX0 <= '1' & seg0;
    HEX1 <= '1' & seg1;
    HEX2 <= '0' & seg2;   -- seconds/centiseconds separator, always lit
    HEX3 <= '1' & seg3;
    HEX4 <= '0' & seg4;   -- minutes/seconds separator, always lit
    HEX5 <= '1' & seg5;

end architecture rtl;
