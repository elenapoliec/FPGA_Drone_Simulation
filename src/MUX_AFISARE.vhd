library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.COORDONATE.all;

entity MUX_AFISARE is
    Port ( 
        SEL : in  STD_LOGIC_VECTOR(1 downto 0); -- swich 
        COORD_FINAL : in  coord_type; 
        COORD_ACTUAL : in  coord_type; -- iesirea din mux-ul pt obstacol
        
        OUT_MINUTE : out integer range 0 to 60;
        OUT_SECUNDE : out integer range 0 to 60
    );
end MUX_AFISARE;

architecture Behavioral of MUX_AFISARE is
    signal coord_selectata : coord_type;
begin
    -- aleg ce sa se afiseze pe placuta
    process(SEL, COORD_FINAL, COORD_ACTUAL)
    begin
        case SEL is
            when "00" => coord_selectata <= COORD_ACTUAL; -- vedem pnt actual 
            when "01" => coord_selectata <= COORD_FINAL;  -- vedem pnt final
            when others => coord_selectata <= (0,0);
        end case;
    end process;

    -- despart in cele 2 parti coordonata (x, y)
    OUT_MINUTE <= coord_selectata.minute;
    OUT_SECUNDE <= coord_selectata.secunde;

end Behavioral;