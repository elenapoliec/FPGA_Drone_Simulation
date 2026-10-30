library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.COORDONATE.all;

entity SUM_COORD is
    Port (
        a : in coord_type;
        b : in INTEGER := 10;
        y : out coord_type
    );
end SUM_COORD;

architecture Behavioral of SUM_COORD is
begin

    process(a, b)
        variable temp_sec : integer;
    begin

        temp_sec := a.secunde + b;

        if temp_sec >= 60 then

            y.minute <= a.minute + 1;
            y.secunde <= temp_sec - 60;

        else

            y.minute <= a.minute;
            y.secunde <= temp_sec;

        end if;

    end process;

end Behavioral;