library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BATTERY_SYS is
    Port ( 
        CLK : in  STD_LOGIC; -- 1Hz 
        RESET : in  STD_LOGIC;
        DECREMENT_VAL : in  integer range 0 to 5; --intrarea de la mux
        
        BATT_LEVEL : out integer range 0 to 100;
        LOW_BATT : out STD_LOGIC; 
        CRITICAL_BATT : out STD_LOGIC  
    );
end BATTERY_SYS;

architecture Behavioral of BATTERY_SYS is
    signal batt_reg : integer range 0 to 100 := 100;
begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            batt_reg <= 100;
        elsif rising_edge(CLK) then
            if batt_reg > 0 then  --verific daca drona e pornita si bateria are curent
                -- scad valoarea primita de la MUX
                if batt_reg >= DECREMENT_VAL then  
                    batt_reg <= batt_reg - DECREMENT_VAL;
                else
                    batt_reg <= 0; -- protectie sa nu devina negativa
                end if;
            end if;
        end if;
    end process;

    BATT_LEVEL <= batt_reg;  --aceasta iesire o trimit catre BATT_COMPARATOR
     
end Behavioral;