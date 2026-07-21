-- EEEN11102 Digital Electronics
-- The University of Manchester
-- Assignment 5.1 - completed (syntax fixed, hex digits A-F added)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder is
    port ( num : in  STD_LOGIC_VECTOR (3 downto 0);  -- 4-bit binary number
           seg : out STD_LOGIC_VECTOR (6 downto 0)); -- 7-segment display
end encoder;

architecture behavioural of encoder is
begin
    process(all)
    begin
            -- Segment order: "gfedcba"
            -- '1' is OFF, '0' is ON
        case num is
                when "0000" => seg <= "1000000";  -- 0
                when "0001" => seg <= "1111001";  -- 1
                when "0010" => seg <= "0100100";  -- 2
                when "0011" => seg <= "0110000";  -- 3
                when "0100" => seg <= "0011001";  -- 4
                when "0101" => seg <= "0010010";  -- 5
                when "0110" => seg <= "0000010";  -- 6
                when "0111" => seg <= "1111000";  -- 7
                when "1000" => seg <= "0000000";  -- 8
                when "1001" => seg <= "0010000";  -- 9
                when "1010" => seg <= "0001000";  -- A
                when "1011" => seg <= "0000011";  -- b
                when "1100" => seg <= "1000110";  -- C
                when "1101" => seg <= "0100001";  -- d
                when "1110" => seg <= "0000110";  -- E
                when "1111" => seg <= "0001110";  -- F
                when others => seg <= "0111111";
        end case;
    end process;
end behavioural;
