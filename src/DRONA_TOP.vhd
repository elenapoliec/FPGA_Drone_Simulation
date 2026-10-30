library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.COORDONATE.all;

entity DRONA_TOP is
    Port (
        CLK_100MHZ : in  STD_LOGIC;
        RESET : in  STD_LOGIC;

        START : in  STD_LOGIC;
        BTN_S : in  STD_LOGIC;
        BTN_F : in  STD_LOGIC;
        CONFIRM_BT : in  STD_LOGIC;

        SW_VAL : in  STD_LOGIC_VECTOR(7 downto 0);
        GEN_DRUM_SW : in  STD_LOGIC;
        OBS_SW : in  STD_LOGIC;
        GPS_SW : in  STD_LOGIC;
        BATT_LOW_SW : in  STD_LOGIC;
        BATT_CRIT_SW : in  STD_LOGIC;
        RTL_SW : in  STD_LOGIC;

        LED_CONF_START : out STD_LOGIC;
        LED_CONF_FINAL : out STD_LOGIC;
        LED_GEN_DONE : out STD_LOGIC;
        LED_VERIF : out STD_LOGIC;
        LED_DECOLARE : out STD_LOGIC;
        LED_MOTOARE : out STD_LOGIC;
        LED_NAVIGATIE : out STD_LOGIC;
        LED_OBSTACOL : out STD_LOGIC;
        LED_OCOLIRE : out STD_LOGIC;
        LED_RETUR_OK : out STD_LOGIC;
        LED_ATERIZARE_OK : out STD_LOGIC;
        LED_ATERIZARE_FAIL : out STD_LOGIC;
        LED_URGENTA : out STD_LOGIC;
        LED_SW_RETUR : out STD_LOGIC;
        LED_MISIUNE_GATA : out STD_LOGIC;
        LED_ALARMA : out STD_LOGIC;

        AN : out STD_LOGIC_VECTOR(7 downto 0);
        CAT : out STD_LOGIC_VECTOR(6 downto 0);
        DP : out STD_LOGIC
    );
end DRONA_TOP;

architecture Structural of DRONA_TOP is

---------------------------------------------------
-- CLOCK
signal clk_1hz : std_logic;
signal clk_view : std_logic;

---------------------------------------------------
-- COORD
signal c_start_wire : coord_type;
signal c_final_wire : coord_type;

signal coord_ram : coord_type; --vine din RAM 
signal coord_display : coord_type; --ce se afiseaz

---------------------------------------------------
-- UC
signal sig_state_code : std_logic_vector(3 downto 0);--starea in care se afla
signal sig_motor_en : std_logic;
signal sig_start_gen : std_logic;
signal sig_ready_gen : std_logic;
signal sig_dir_retur : std_logic;
signal sig_retur_done : std_logic;

---------------------------------------------------
-- RAM
signal ram_addr_gen : std_logic_vector(6 downto 0);
signal ram_we : std_logic;
signal addr_q : std_logic_vector(6 downto 0);
signal mux_addr : std_logic_vector(6 downto 0);
signal coord_gen_data : coord_type;

---------------------------------------------------
-- MPG
signal start_pulse : std_logic;
signal btn_s_pulse : std_logic;
signal btn_f_pulse : std_logic;
signal confirm_pulse : std_logic;

---------------------------------------------------
-- LED intern
signal step_s_wire : std_logic;
signal step_f_wire : std_logic;

signal gen_done_latched : std_logic := '0';

---------------------------------------------------
-- TIMER LAND
signal t10_q    : std_logic_vector(3 downto 0);
signal t10_done : std_logic;

signal en_t10 : std_logic;

---------------------------------------------------
-- LAND STATUS
signal land_ok_latched   : std_logic := '0';
signal land_fail_latched : std_logic := '0';

---------------------------------------------------
-- FINAL TRASEU
signal mission_done : std_logic;

signal addr_freeze : std_logic;

begin

DP <= '1';

---------------------------------------------------
-- MPG
MPG_START : entity work.MPG
port map(
    btn => START,
    clk => CLK_100MHZ,
    en  => start_pulse
);

MPG_S : entity work.MPG
port map(
    btn => BTN_S,
    clk => CLK_100MHZ,
    en  => btn_s_pulse
);

MPG_F : entity work.MPG
port map(
    btn => BTN_F,
    clk => CLK_100MHZ,
    en  => btn_f_pulse
);

MPG_C : entity work.MPG
port map(
    btn => CONFIRM_BT,
    clk => CLK_100MHZ,
    en  => confirm_pulse
);

---------------------------------------------------
-- DIVIZOR
DIV : entity work.DIVIZOR_FRECVENTA
port map(
    CLK_100  => CLK_100MHZ,
    Reset    => RESET,
    CLK_1Hz  => clk_1hz,
    CLK_VIEW => clk_view
);

---------------------------------------------------
-- GESTIUNE COORDONATE
GEST : entity work.GESTIUNE_COORDONATE
port map(
    CLK => CLK_100MHZ,
    RESET => RESET,
    SW_VAL => SW_VAL,
    BTN_S => btn_s_pulse,
    BTN_F => btn_f_pulse,
    C_START => c_start_wire,
    C_FINAL => c_final_wire,
    LED_STEP_S => step_s_wire,
    LED_STEP_F => step_f_wire
);

---------------------------------------------------
-- GENERARE RAM
GEN : entity work.RAM_COORD_GEN
port map(
    CLK => CLK_100MHZ,
    RESET => RESET,
    EN => '1',
    C_START => c_start_wire,
    C_FINAL => c_final_wire,
    START_GEN => sig_start_gen,
    RAM_WE => ram_we,
    RAM_ADDR => ram_addr_gen,
    RAM_DIN => coord_gen_data,
    READY => sig_ready_gen
);

---------------------------------------------------
-- RAM
mux_addr <= ram_addr_gen when sig_start_gen = '1'
            else addr_q;

RAM : entity work.RAM_COORDONATE_MISIUNE
port map(
    CLK => CLK_100MHZ,
    WE => ram_we,
    ADDR => mux_addr,
    DIN => coord_gen_data,
    DOUT => coord_ram
);

---------------------------------------------------
-- CONTOR ADRESE
addr_freeze <= mission_done;

ADDR_COUNTER : entity work.NUM_ADRESE
port map(
    RESET => RESET,
    CLK => clk_view,
    EN => sig_motor_en,
    DIR => sig_dir_retur,
    Q => addr_q,
    MAX_ADDR => mission_done
);

---------------------------------------------------
-- TIMER 10 SEC
en_t10 <= '1' when sig_state_code = "1000"
          else '0';

TIMER_LAND_I : entity work.TIMER_LAND
port map(
    RESET10 => RESET,
    EN10 => en_t10,
    CLK10 => clk_1hz,
    T10 => t10_done,
    Q10 => t10_q
);

---------------------------------------------------
-- UNITATE CONTROL
UC : entity work.UC_DRONA
port map(
    CLK => CLK_100MHZ,
    RESET => RESET,
    START_BTN => start_pulse,
    GEN_DRUM_SW => GEN_DRUM_SW,
    CONFIRM_LAND => confirm_pulse,
    GPS_LOST => GPS_SW,
    OBS => OBS_SW,
    BATT_LOW => BATT_LOW_SW,
    BATT_CRIT => BATT_CRIT_SW,
    RTL_SW => RTL_SW,
    READY_GEN => sig_ready_gen,
    RETUR_DONE => sig_retur_done,
    MISSION_DONE => mission_done,
    T10_DONE => t10_done,
    START_GEN => sig_start_gen,
    MOTOR_EN => sig_motor_en,
    DIR_RETUR => sig_dir_retur,
    ALARM => LED_ALARMA,
    STATE_LED => sig_state_code
);

---------------------------------------------------
-- RETUR DONE
sig_retur_done <= '1'
when (sig_state_code = "0110" and addr_q = "0000000")
else '0';

---------------------------------------------------
-- GEN DONE LED
process(CLK_100MHZ)
begin
    if rising_edge(CLK_100MHZ) then

        if RESET = '1' then
            gen_done_latched <= '0';

        elsif sig_ready_gen = '1' then
            gen_done_latched <= '1';

        end if;

    end if;
end process;

---------------------------------------------------
-- LAND STATUS
process(CLK_100MHZ)
begin
    if rising_edge(CLK_100MHZ) then

        if RESET = '1' then

            land_ok_latched <= '0';
            land_fail_latched <= '0';

        else

            if sig_state_code = "1000" then

                if confirm_pulse = '1' then

                    land_ok_latched <= '1';
                    land_fail_latched <= '0';

                elsif t10_done = '1' then

                    land_ok_latched <= '0';
                    land_fail_latched <= '1';

                end if;

            end if;

        end if;

    end if;
end process;

---------------------------------------------------
-- DISPLAY
process(sig_state_code, coord_ram)
begin

    if sig_state_code = "0000" then

        coord_display.minute <= 0;
        coord_display.secunde <= 0;

    else

        coord_display <= coord_ram;

    end if;

end process;

---------------------------------------------------
-- AFISARE
DISP : entity work.MUX_AFISARE_TOT
port map(
    CLK_100MHz => CLK_100MHZ,
    STATE => sig_state_code,
    T10_VAL => to_integer(unsigned(t10_q)),
    COORD => coord_display,
    ANODE => AN(3 downto 0),
    CATHODE => CAT
);

AN(7 downto 4) <= "1111";

---------------------------------------------------
-- LED URI
LED_CONF_START <= step_s_wire;
LED_CONF_FINAL <= step_f_wire;

LED_GEN_DONE <= gen_done_latched;

LED_VERIF <= '1'
when sig_state_code = "0010"
else '0';

LED_DECOLARE <= '1'
when sig_state_code = "0011"
else '0';

LED_MOTOARE <= sig_motor_en;

LED_NAVIGATIE <= '1'
when sig_state_code = "0100"
else '0';

LED_OBSTACOL <= OBS_SW;
LED_OCOLIRE  <= OBS_SW;

LED_RETUR_OK <= sig_dir_retur;

LED_ATERIZARE_OK <= land_ok_latched;

--LED_ATERIZARE_FAIL <=land_fail_latched or BATT_CRIT_SW;
    
LED_ATERIZARE_FAIL <=land_fail_latched;

LED_URGENTA <= GPS_SW or BATT_CRIT_SW;

LED_SW_RETUR <= RTL_SW;

LED_MISIUNE_GATA <= '1'
when sig_state_code = "0000"
else '0';

end Structural;