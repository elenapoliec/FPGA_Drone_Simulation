library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECO_7SEG is
    Port (
        CIFRA : in STD_LOGIC_VECTOR (3 downto 0);
        SEG   : out STD_LOGIC_VECTOR (6 downto 0)
    );
end DECO_7SEG;

architecture Behavioral of DECO_7SEG is
begin

    process(CIFRA)
    begin

        -- 0 = aprins
        -- 1 = stins

        case CIFRA is

            when "0000" => SEG <= "0000001"; -- 0
            when "0001" => SEG <= "1001111"; -- 1
            when "0010" => SEG <= "0010010"; -- 2
            when "0011" => SEG <= "0000110"; -- 3
            when "0100" => SEG <= "1001100"; -- 4
            when "0101" => SEG <= "0100100"; -- 5
            when "0110" => SEG <= "0100000"; -- 6
            when "0111" => SEG <= "0001111"; -- 7
            when "1000" => SEG <= "0000000"; -- 8
            when "1001" => SEG <= "0000100"; -- 9
            when others => SEG <= "1111111"; -- toate stinse

        end case;

    end process;

end Behavioral;