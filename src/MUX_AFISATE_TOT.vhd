library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.COORDONATE.all;

entity MUX_AFISARE_TOT is
    Port ( 
        CLK_100MHz : in  STD_LOGIC;
        STATE : in  STD_LOGIC_VECTOR(3 downto 0);
        T10_VAL : in  integer range 0 to 15;
        COORD : in  coord_type;
        ANODE : out STD_LOGIC_VECTOR(3 downto 0);
        CATHODE : out STD_LOGIC_VECTOR(6 downto 0)
    );
end MUX_AFISARE_TOT;

architecture Behavioral of MUX_AFISARE_TOT is

    signal refresh_counter : unsigned(19 downto 0) := (others => '0');

    signal seg_min_z, seg_min_u : std_logic_vector(6 downto 0);
    signal seg_sec_z, seg_sec_u : std_logic_vector(6 downto 0);

    signal seg_timer : std_logic_vector(6 downto 0);
    signal hex_digit : std_logic_vector(3 downto 0);

begin

    
    -- conversie coordonate
    AFIS_MIN: entity work.DISPLAY_COORD
        port map(
            VAL => COORD.minute,
            SEG_Z => seg_min_z,
            SEG_U => seg_min_u
        );

    AFIS_SEC: entity work.DISPLAY_COORD
        port map(
            VAL => COORD.secunde,
            SEG_Z => seg_sec_z,
            SEG_U => seg_sec_u
        );

   
    -- refresh display
    --il folosesc ca sa se aleaga pe ce bit de pe afisor sa se afiseze
    --pt ca nu se afiseaza simultan doar pare asa
    process(CLK_100MHz)
    begin
        if rising_edge(CLK_100MHz) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;

    
    -- multiplexare display
    process(refresh_counter(19 downto 18), STATE,
            seg_min_z, seg_min_u, seg_sec_z, seg_sec_u, seg_timer, T10_VAL)
    begin

        case refresh_counter(19 downto 18) is 

            -- DIGIT 0 (secunde unitati / timer)
            when "00" =>
                ANODE <= "1110";

                if STATE = "1000" then
                    hex_digit <= std_logic_vector(to_unsigned(T10_VAL mod 10, 4));
                    CATHODE <= seg_timer;

                elsif STATE = "0000" then  
                    CATHODE <= "1111111"; --di[lay stins
                    hex_digit <= "1111"; --valoare invalida , folosesc ca sa nu se mai afiseze nimic pe afisor

                else
                    CATHODE <= seg_sec_u;  --daca nu este time/IDLE sunt secundele 
                    hex_digit <= "1111"; 
                end if;

           
           
            -- DIGIT 1 (secunde zeci / timer)
            when "01" =>
                ANODE <= "1101";

                if STATE = "1000" then
                    hex_digit <= std_logic_vector(to_unsigned(T10_VAL / 10, 4));
                    CATHODE <= seg_timer;

                elsif STATE = "0000" then 
                    CATHODE <= "1111111";
                    hex_digit <= "1111";

                else
                    CATHODE <= seg_sec_z;
                    hex_digit <= "1111";
                end if;

          
          
            -- DIGIT 2 (minute unitati)
            when "10" =>
                ANODE <= "1011";

                if STATE = "0000" then
                    CATHODE <= "1111111";
                else
                    CATHODE <= seg_min_u;
                end if;

                hex_digit <= "1111";

       
       
            -- DIGIT 3 (minute zeci)
            when "11" =>
                ANODE <= "0111";

                if STATE = "0000" then
                    CATHODE <= "1111111";
                else
                    CATHODE <= seg_min_z;
                end if;

                hex_digit <= "1111";

            when others =>
                ANODE <= "1111";
                CATHODE <= "1111111";
                hex_digit <= "1111";

        end case;

    end process;

   
    -- decoder auxiliar pentru timer
    DECO_AUX: entity work.DECO_7SEG
        port map(
            CIFRA => hex_digit,
            SEG => seg_timer
        );

end Behavioral;