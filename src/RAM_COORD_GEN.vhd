
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.COORDONATE.all;


entity RAM_COORD_GEN is
    Port ( CLK : in STD_LOGIC;
           RESET : in STD_LOGIC;
           EN : in STD_LOGIC;
           C_START : in coord_type;
           C_FINAL : in coord_type;
           C_OUT : out coord_type;
           START_GEN   : in STD_LOGIC; -- semnal de la UC: "genereaza traseul acum"
           
           -- Interfata cu RAM
           RAM_WE : out STD_LOGIC;
           RAM_ADDR : out STD_LOGIC_VECTOR(6 downto 0);
           RAM_DIN : out coord_type;
           READY : out STD_LOGIC -- Semnal catre UC: "traseul este gata"
        );
           
end RAM_COORD_GEN;

architecture Behavioral of RAM_COORD_GEN is

       -- Semnale pentru calcul 
    type state_type is (IDLE, GENERATING, DONE);
    signal state : state_type := IDLE;
    signal counter : integer range 0 to 100 := 0;
    signal curr_m, curr_s : integer;

begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            state <= IDLE;
            counter <= 0;
            READY <= '0';
            RAM_WE <= '0';
        elsif rising_edge(CLK) then
            case state is
                when IDLE =>
                    READY <= '0';
                    if START_GEN = '1' then
                        state <= GENERATING;
                        counter <= 0;
                    end if;

                when GENERATING =>
                    if counter < 100 then
                        RAM_WE <= '1';
                        RAM_ADDR <= std_logic_vector(to_unsigned(counter, 7));  --arata la ce pozitie din RAM scriu
                        
                        -- Traseu=o dreata=ec de gr 1 
                        -- Punct_i = Start + (Final - Start) * i / 99
                        --RAM_DIN.grade   <= C_START.grade   + ((C_FINAL.grade   - C_START.grade)   * counter) / 99;
                        RAM_DIN.minute  <= C_START.minute  + ((C_FINAL.minute  - C_START.minute)  * counter) / 99;
                        RAM_DIN.secunde <= C_START.secunde + ((C_FINAL.secunde - C_START.secunde) * counter) / 99;
                        --RAM_DIN folosesc ca sa pun valoarea pe care o s-o scriu in memorie
                        --la pozitia RAM_ADDR scriu coordonata RAM_DIN
                        counter <= counter + 1;
                    else
                        RAM_WE <= '0';
                        state <= DONE;
                    end if;

                when DONE =>
                    READY <= '1';
                    if START_GEN = '0' then state <= IDLE; --din UC o sa vina pt START_GEN setarea 0
                     end if;
            end case;
        end if;
    end process;

end Behavioral;
