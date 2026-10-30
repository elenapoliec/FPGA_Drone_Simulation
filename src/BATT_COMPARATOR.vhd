
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BATT_COMPARATOR is
    Port ( BATT_LEVEL : in integer range 0 to 100 ;
           LOW_LIMIT : in integer := 20;
           CRITICAL_LIMIT : in integer := 5;
           LOW_BATT : out STD_LOGIC;
           CRITICAL_BATT : out STD_LOGIC);
end BATT_COMPARATOR;

architecture Behavioral of BATT_COMPARATOR is

begin
    process(BATT_LEVEL, LOW_LIMIT, CRITICAL_LIMIT)
    begin
        -- baterie scazuta (20%)
        if BATT_LEVEL <= LOW_LIMIT then
            LOW_BATT <= '1';
        else
            LOW_BATT <= '0';
        end if;

        -- baterie prea descarcata (5%)
        if BATT_LEVEL <= CRITICAL_LIMIT then
            CRITICAL_BATT <= '1';
        else
            CRITICAL_BATT <= '0';
        end if;
    end process;


end Behavioral;
