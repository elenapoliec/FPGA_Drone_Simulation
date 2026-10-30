library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BATT_MUX is
    Port ( 
        -- SEL vine de la Unitatea de Control
        -- "00" -> IDLE / reset
        -- "01" -> navigare / retur / aterizare
        -- "10" -> citire coordonate
        SEL : in  STD_LOGIC_VECTOR(1 downto 0); 
        
        DECREMENT_VALUE : out integer range 0 to 5
    );
end BATT_MUX;

architecture Behavioral of BATT_MUX is
begin

    process(SEL)
    begin
        case SEL is
            when "00" => 
                DECREMENT_VALUE <= 1; -- verificare (1%)
            when "01" => 
                DECREMENT_VALUE <= 2; -- navigatie (2%)
            when "10" => 
                DECREMENT_VALUE <= 5; -- preluarea coordonatelor (5%)
            when others => 
                DECREMENT_VALUE <= 0; -- drona oprita/resetare (0%)
        end case;
    end process;

end Behavioral;