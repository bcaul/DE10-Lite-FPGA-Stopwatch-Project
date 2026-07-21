-- EEEN11102 Digital Electronics
-- The University of Manchester
-- Assignment 5.2 - top level with KEY1 reset button (7-bit HEX, no FSM yet)
-- NOTE: this version is superseded by stopwatch.vhd after completion of Assignment 5.3,
-- which replaces the direct run/clr wiring with the fsm_control module.

library ieee;
use ieee.std_logic_1164.all;

entity stopwatch is
    port (
        CLOCK_50 : in  std_logic;
        KEY0     : in  std_logic; -- Start/Stop push-button (active low)
        KEY1     : in  std_logic; -- Reset push-button (active low)
        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0);
        HEX4     : out std_logic_vector(6 downto 0);
        HEX5     : out std_logic_vector(6 downto 0)
    );
end entity stopwatch;
architecture rtl of stopwatch is

    -- Internal signals
    signal clk, run, clr          : std_logic;
    signal d0, d1, d2, d3, d4, d5 : std_logic_vector(3 downto 0);

begin

    run <= not KEY0; -- inverted because pushbutton is active low
    clr <= not KEY1; -- inverted because pushbutton is active low

    -- Clock divider: 50 MHz -> 100 Hz tick
    u_div : entity work.clock_divider
        port map ( clk_50 => CLOCK_50, clk => clk );

    -- BCD counter
    u_cnt : entity work.bcd_counter
        port map (
            clk => clk, run => run, clr => clr,
            d0  => d0, d1 => d1, d2 => d2,
            d3  => d3, d4 => d4, d5 => d5
        );

    -- Six encoder instances, one per display digit
    enc0 : entity work.encoder port map ( num => d0, seg => HEX0 );
    enc1 : entity work.encoder port map ( num => d1, seg => HEX1 );
    enc2 : entity work.encoder port map ( num => d2, seg => HEX2 );
    enc3 : entity work.encoder port map ( num => d3, seg => HEX3 );
    enc4 : entity work.encoder port map ( num => d4, seg => HEX4 );
    enc5 : entity work.encoder port map ( num => d5, seg => HEX5 );

end architecture rtl;
