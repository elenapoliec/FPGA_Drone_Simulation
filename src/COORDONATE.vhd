library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package COORDONATE is
    type coord_type is record
        minute : integer range 0 to 99;
        secunde : integer range 0 to 99;
    end record;
    
    type traseu_array is array (0 to 99) of coord_type;
end package;