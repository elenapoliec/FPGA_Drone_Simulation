library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC_DRONA is
    Port (
        CLK : in  STD_LOGIC;
        RESET : in  STD_LOGIC;

        START_BTN : in  STD_LOGIC;
        GEN_DRUM_SW : in  STD_LOGIC;
        CONFIRM_LAND : in  STD_LOGIC;

        GPS_LOST : in  STD_LOGIC;
        OBS : in  STD_LOGIC;

        BATT_LOW : in  STD_LOGIC;
        BATT_CRIT : in  STD_LOGIC;

        RTL_SW : in  STD_LOGIC;

        READY_GEN : in  STD_LOGIC;
        RETUR_DONE : in  STD_LOGIC;

        START_GEN : out STD_LOGIC;
        MOTOR_EN : out STD_LOGIC;
        DIR_RETUR : out STD_LOGIC;
        ALARM : out STD_LOGIC;

        STATE_LED : out STD_LOGIC_VECTOR(3 downto 0);

        LAND_OK : out STD_LOGIC;
        LAND_FAIL : out STD_LOGIC;
        
        MISSION_DONE : in STD_LOGIC;
        T10_DONE  : in STD_LOGIC
    );
end UC_DRONA;

architecture Behavioral of UC_DRONA is

    type state_type is (
        ST_IDLE,
        ST_GEN_RAM,
        ST_READY,
        ST_DECOLARE,
        ST_NAVIGARE,
        ST_OBSTACOL,
        ST_RETUR,
        ST_ATERIZARE,
        ST_WAIT_LAND
    );

    signal current_state, next_state : state_type;

    signal start_latched : std_logic := '0'; --stare pt start

    signal land_timer_en : std_logic := '0';
    signal land_counter  : integer range 0 to 10 := 0;

    signal land_ok_i   : std_logic := '0';
    signal land_fail_i : std_logic := '0';
    
    
    signal rtl_request : std_logic := '0'; --pt afisarea timerului la retur manual fara sa dezactivez eu swich-ul
    
    signal land_delay_done : std_logic := '0';
    signal land_delay_cnt  : integer range 0 to 1 := 0;
    
    signal mission_phase_return : std_logic := '0';  
    signal mission_completed : std_logic := '0';  --il folosesc ca sa fac returul automat la miniune normala

begin


-- START LATCH
process(CLK)
begin
    if rising_edge(CLK) then
        if RESET = '1' then
            start_latched <= '0';
        elsif START_BTN = '1' then
            start_latched <= '1';
        end if;
    end if;
end process;



-- RTL REQUEST LATCH
process(CLK)
begin
    if rising_edge(CLK) then

        if RESET = '1' then
            rtl_request <= '0';
        else

           -- memoram cererea de retur
            if RTL_SW = '1' then
                rtl_request <= '1';
            end if;


            -- dupa ce am ajuns acasa stergem cererea
            if current_state = ST_WAIT_LAND then
                rtl_request <= '0';
            end if;

        end if;

    end if;
end process;



----------------------------------------------------------- 
process(CLK)
begin
    if rising_edge(CLK) then

        if RESET = '1' then

            mission_completed <= '0';

        else


            -- aterizare pt ca am ajuns la final
            if current_state = ST_NAVIGARE and
               MISSION_DONE = '1' then

                mission_completed <= '1';

            end if;
            
           
            -- dupa prima aterizare confirmata pornesc returul si sterg flagul
            if current_state = ST_WAIT_LAND and
               CONFIRM_LAND = '1' and
               mission_completed = '1' then

                mission_completed <= '0';

            end if;

           
            -- aterizare de urgenta
            if BATT_CRIT = '1' or GPS_LOST = '1' then

                mission_completed <= '0';

            end if;

            -- reset total
            if current_state = ST_IDLE then

                mission_completed <= '0';

            end if;

        end if;

    end if;
end process;

------------------------------------------------------------ 



-- STATE REGISTER
process(CLK)
begin
    if rising_edge(CLK) then
        if RESET = '1' then
            current_state <= ST_IDLE;
        else
            current_state <= next_state;
        end if;
    end if;
end process;




-- DELAY AFISARE COORDONATA FINALA
process(CLK)
begin
    if rising_edge(CLK) then

        if RESET = '1' then

            land_delay_cnt  <= 0;
            land_delay_done <= '0';

        elsif current_state = ST_ATERIZARE then

            if land_delay_cnt < 1 then

                land_delay_cnt <= land_delay_cnt + 1;
                land_delay_done <= '0';

            else

                land_delay_done <= '1';

            end if;

        else

            land_delay_cnt  <= 0;
            land_delay_done <= '0';

        end if;

    end if;
end process;




-- TIMER 10 SEC LAND
process(CLK)
begin
    if rising_edge(CLK) then
        if RESET = '1' then
            land_counter <= 0;
            land_ok_i <= '0';
            land_fail_i <= '0';

        elsif land_timer_en = '1' then

            if CONFIRM_LAND = '1' then
                land_ok_i <= '1';
                land_fail_i <= '0';
                land_counter <= 0;

            elsif land_counter < 10 then
                land_counter <= land_counter + 1;

            else
                land_fail_i <= '1';
                land_ok_i <= '0';
            end if;

        else
            land_counter <= 0;
            land_ok_i <= '0';
            land_fail_i <= '0';
        end if;
    end if;
end process;



-- FSM
process(current_state, GEN_DRUM_SW, READY_GEN,
        GPS_LOST, OBS, BATT_LOW, BATT_CRIT,
        RTL_SW, start_latched, RETUR_DONE,
        land_ok_i, land_fail_i)
begin

    next_state <= current_state;
    land_timer_en <= '0';

    if RTL_SW = '1' and current_state /= ST_RETUR then
    next_state <= ST_RETUR;  --daca am dat retur manual se renunta la tot si se face returul

    elsif BATT_CRIT = '1' or GPS_LOST = '1' then
        next_state <= ST_ATERIZARE;

    else

        case current_state is

            when ST_IDLE =>
                if GEN_DRUM_SW = '1' then
                    next_state <= ST_GEN_RAM;
                end if;

            when ST_GEN_RAM =>
                if READY_GEN = '1' then
                    next_state <= ST_READY;
                end if;

            when ST_READY =>
                if start_latched = '1' then
                    next_state <= ST_DECOLARE;
                end if;

            when ST_DECOLARE =>
                next_state <= ST_NAVIGARE;

            when ST_NAVIGARE =>
                 if MISSION_DONE = '1' then
                        next_state <= ST_ATERIZARE;

                 elsif BATT_LOW = '1' then
                        next_state <= ST_RETUR;

                    elsif OBS = '1' then
                            next_state <= ST_OBSTACOL;
                     end if;

            when ST_OBSTACOL =>
                if OBS = '0' then
                    next_state <= ST_NAVIGARE;
                end if;

            when ST_RETUR =>
                if RETUR_DONE = '1' then
                    next_state <= ST_ATERIZARE;
                end if;

              
              when ST_ATERIZARE =>
                    if land_delay_done = '1' then
                        next_state <= ST_WAIT_LAND;
                     end if;

            
     when ST_WAIT_LAND =>
    -- aterizare confirmata
    if CONFIRM_LAND = '1' then
    
        -- daca misiunea s-a terminat pornesc returul
        if mission_completed = '1' then
             next_state <= ST_RETUR;

        -- daca a fost urgenta fac stop total
        else
             next_state <= ST_IDLE;

        end if;

    -- timeout aterizare
    elsif T10_DONE = '1' then
        next_state <= ST_IDLE;

    end if;
     

            when others =>
                next_state <= ST_IDLE;

        end case;
    end if;
end process;


-- OUTPUTURI
START_GEN <= '1' when current_state = ST_GEN_RAM else '0';

MOTOR_EN <= '1' when
    current_state = ST_DECOLARE or
    current_state = ST_NAVIGARE or
    current_state = ST_OBSTACOL or
    current_state = ST_RETUR
else '0';

DIR_RETUR <= '1' when current_state = ST_RETUR else '0';

ALARM <= GPS_LOST or BATT_CRIT;

LAND_OK <= land_ok_i;
LAND_FAIL <= land_fail_i;


-- STATE LED
with current_state select
STATE_LED <=
    "0000" when ST_IDLE,
    "0001" when ST_GEN_RAM,
    "0010" when ST_READY,
    "0011" when ST_DECOLARE,
    "0100" when ST_NAVIGARE,
    "0101" when ST_OBSTACOL,
    "0110" when ST_RETUR,
    "0111" when ST_ATERIZARE,
    "1000" when ST_WAIT_LAND,
    "1111" when others;

end Behavioral;