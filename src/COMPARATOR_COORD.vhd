
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 
use work.COORDONATE.all;


entity COMPARATOR_COORD is
    Port ( COORD_ROM : in coord_type;
           COORD_GEN : in coord_type;
           COORD_FINAL : out coord_type);
end COMPARATOR_COORD;

architecture Behavioral of COMPARATOR_COORD is

begin

    process(COORD_ROM, COORD_GEN)
        variable diff_m : integer;
        variable diff_s : integer;
    begin
       
        diff_m := COORD_ROM.minute - COORD_GEN.minute;
        diff_s := COORD_ROM.secunde - COORD_GEN.secunde;
        
        COORD_FINAL.minute  <= COORD_GEN.minute + diff_m;
        COORD_FINAL.secunde <= COORD_GEN.secunde + diff_s; 
        
    end process;


end Behavioral;
