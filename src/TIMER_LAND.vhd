library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TIMER_LAND is
    Port (
        RESET10 : in STD_LOGIC;
        EN10    : in STD_LOGIC;
        CLK10   : in STD_LOGIC;
        T10     : out STD_LOGIC;
        Q10     : out STD_LOGIC_VECTOR (3 downto 0)
    );
end TIMER_LAND;

architecture Behavioral of TIMER_LAND is

    signal count : unsigned(3 downto 0) := (others => '0');

begin

process(CLK10, RESET10)
begin

    if RESET10 = '1' then
        count <= (others => '0');
        T10 <= '0';

    elsif rising_edge(CLK10) then

        if EN10 = '1' then

            if count < 9 then

                count <= count + 1;
                T10 <= '0';

            else

                count <= count;
                T10 <= '1';

            end if;

        else

            count <= (others => '0');
            T10 <= '0';

        end if;

    end if;

end process;

Q10 <= std_logic_vector(count);

end Behavioral;