
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.COORDONATE.all; 

entity MUX_OBSTACOL is
    Port ( IN_COR : in coord_type; --coordonata dupa verificare si corectare
           IN_SUM : in coord_type; --coordonata din sumator
           SEL : in STD_LOGIC;  --reprezinta butonul obs din placuta
           DOUT : out coord_type);
end MUX_OBSTACOL;

architecture Behavioral of MUX_OBSTACOL is

begin

   process(SEL, IN_COR, IN_SUM)
begin
    if SEL = '1' then 
        DOUT <= IN_SUM; -- ocolire
    else 
        DOUT <= IN_COR; -- normal
    end if;
end process;
     
end Behavioral;
