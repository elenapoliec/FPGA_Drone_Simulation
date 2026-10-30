library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NUM_ADRESE is
    Port (
        RESET : in STD_LOGIC;
        CLK : in STD_LOGIC;
        EN : in STD_LOGIC;
        DIR : in STD_LOGIC; -- 0 = in fata, 1 = retur
        Q : out STD_LOGIC_VECTOR (6 downto 0);
        MAX_ADDR : out STD_LOGIC
    );
end NUM_ADRESE;

architecture Behavioral of NUM_ADRESE is

    signal count_reg : integer range 0 to 99 := 0;  --pozitia dronei pe traseu

begin

process(RESET, CLK)
begin
    if RESET = '1' then
        count_reg <= 0;

    elsif rising_edge(CLK) then

        if EN = '1' then

            -- navigare normala
            if DIR = '0' then
                if count_reg < 99 then
                    count_reg <= count_reg + 1;
                else
                    count_reg <= 99;
                end if;

            -- retur
            else
                if count_reg > 0 then
                    count_reg <= count_reg - 1;
                else
                    count_reg <= 0;
                end if;
            end if;

        end if;
    end if;
end process;

Q <= std_logic_vector(to_unsigned(count_reg, 7));
MAX_ADDR <= '1' when count_reg = 99 else '0';

end Behavioral;