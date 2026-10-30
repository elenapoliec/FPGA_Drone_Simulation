library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.COORDONATE.all;

entity GESTIUNE_COORDONATE is
    Port ( 
        CLK : in  STD_LOGIC;
        RESET : in  STD_LOGIC;
        SW_VAL : in  STD_LOGIC_VECTOR (7 downto 0);
        BTN_S : in  STD_LOGIC;
        BTN_F : in  STD_LOGIC;

        C_START : out coord_type;
        C_FINAL : out coord_type;

        LED_STEP_S : out STD_LOGIC;
        LED_STEP_F : out STD_LOGIC
    );
end GESTIUNE_COORDONATE;

architecture Behavioral of GESTIUNE_COORDONATE is

    signal s_min, s_sec : integer := 0;
    signal f_min, f_sec : integer := 0;

    signal step_s, step_f : std_logic := '0';

    signal btn_s_prev, btn_f_prev : std_logic := '0';

    
    signal led_s_reg : std_logic := '0';
    signal led_f_reg : std_logic := '0';

begin

    process(CLK)
    begin
        if rising_edge(CLK) then

            if RESET = '1' then
                s_min <= 0; s_sec <= 0;
                f_min <= 0; f_sec <= 0;

                step_s <= '0';
                step_f <= '0';

                btn_s_prev <= '0';
                btn_f_prev <= '0';

                led_s_reg <= '0';
                led_f_reg <= '0';

            else

                btn_s_prev <= BTN_S; --primest starea anterioara a butoanelor, adica daca a fos/nu apasat
                btn_f_prev <= BTN_F;

                -- START coordonata
                if BTN_S = '1' and btn_s_prev = '0' then
                     led_s_reg <= '1'; 

                    if step_s = '0' then
                        s_min <= to_integer(unsigned(SW_VAL));
                        step_s <= '1';
                    else
                        s_sec <= to_integer(unsigned(SW_VAL));
                        step_s <= '0';
                    end if;
                end if;

                -- FINAL coordonata
                if BTN_F = '1' and btn_f_prev = '0' then
                        led_f_reg <= '1';

                    if step_f = '0' then
                        f_min <= to_integer(unsigned(SW_VAL));
                        step_f <= '1';
                    else
                        f_sec <= to_integer(unsigned(SW_VAL));
                        step_f <= '0';
                    end if;
                end if;

            end if;
        end if;
    end process;

    C_START.minute <= s_min;
    C_START.secunde <= s_sec;

    C_FINAL.minute <= f_min;
    C_FINAL.secunde <= f_sec;

    LED_STEP_S <= led_s_reg;
    LED_STEP_F <= led_f_reg;

end Behavioral;