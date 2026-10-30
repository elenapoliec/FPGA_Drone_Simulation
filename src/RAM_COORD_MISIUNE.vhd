library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.COORDONATE.all;
--Generator de traseu, nu este chiar RAM-ul , seamana cu el
entity RAM_COORDONATE_MISIUNE is
    Port (
        CLK : in STD_LOGIC;
        WE : in STD_LOGIC;
        ADDR : in STD_LOGIC_VECTOR(6 downto 0);  --primesc de la RAM_COORD_GEN
        DIN : in coord_type; --primesc de la RAM_COORD_GEN
        DOUT : out coord_type
    );
end RAM_COORDONATE_MISIUNE;

architecture Behavioral of RAM_COORDONATE_MISIUNE is

    type ram_type is array (0 to 99) of coord_type;
    signal memorie : ram_type;

begin

    process(CLK)
    begin
        if rising_edge(CLK) then

            if WE = '1' then
                memorie(to_integer(unsigned(ADDR))) <= DIN; --scriu in memorie folosind datele din RAM_COORD_GEN
            end if;

            DOUT <= memorie(to_integer(unsigned(ADDR)));  --preiau/citesc datele din memorie 

        end if;
    end process;

end Behavioral;