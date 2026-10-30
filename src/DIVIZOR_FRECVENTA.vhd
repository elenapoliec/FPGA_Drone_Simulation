library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIVIZOR_FRECVENTA is
    Port (
        CLK_100 : in STD_LOGIC;
        Reset : in STD_LOGIC;
        CLK_1Hz : out STD_LOGIC;
        CLK_VIEW : out STD_LOGIC   
    );
end DIVIZOR_FRECVENTA;

architecture Behavioral of DIVIZOR_FRECVENTA is

    signal cnt_1hz : unsigned(26 downto 0) := (others => '0');
    signal cnt_view : unsigned(22 downto 0) := (others => '0');

begin

    -- 1 Hz
    process(CLK_100, Reset)
    begin
        if Reset = '1' then
            cnt_1hz <= (others => '0');
        elsif rising_edge(CLK_100) then
            cnt_1hz <= cnt_1hz + 1;
        end if;
    end process;

    CLK_1Hz <= cnt_1hz(26);

    -- 12 Hz ca sa se vada pe afisor
    process(CLK_100, Reset)
    begin
        if Reset = '1' then
            cnt_view <= (others => '0');
        elsif rising_edge(CLK_100) then
            cnt_view <= cnt_view + 1;
        end if;
    end process;

    CLK_VIEW <= cnt_view(22);

end Behavioral;