-- EEEN11102 Digital Electronics
-- The University of Manchester
-- Assignment 5.3 - completed FSM controller

library ieee;
use ieee.std_logic_1164.all;

entity fsm_control is
    port (
        clk       : in  std_logic;
        START     : in  std_logic;   -- active low
        STOP      : in  std_logic;   -- active low
        RESET     : in  std_logic;   -- active low
        run       : out std_logic;
        clr       : out std_logic
    );
end fsm_control;

architecture behaviour of fsm_control is

    type t_state is (IDLE, RUNNING, STOPPED);
    signal state      : t_state := IDLE;
    signal next_state : t_state;

begin

    -- State register (clocked)
    process(clk)
    begin
        if rising_edge(clk) then
            state  <= next_state;
        end if;
    end process;

    -- Next-state and Output logic (combinatorial)
    process(all)
    begin
        -- Default assignment (prevents latches)
        next_state <= state;
        run <= '0';
        clr <= '0';

        case state is

            when IDLE =>
                clr <= '1';
                if START = '0' then next_state <= RUNNING; end if;

            when RUNNING =>
                run <= '1';
                if STOP = '0' then
                    next_state <= STOPPED;
                elsif RESET = '0' then
                    next_state <= IDLE;
                end if;

            when STOPPED =>
                -- run and clr both '0' (default) -- counter holds its value
                if START = '0' then
                    next_state <= RUNNING;
                elsif RESET = '0' then
                    next_state <= IDLE;
                end if;

        end case;

    end process;

end architecture behaviour;
