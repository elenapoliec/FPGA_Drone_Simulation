
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TIMER_PRE is
    Port ( RESET5 : in STD_LOGIC;
           EN5 : in STD_LOGIC;
           CLK : in STD_LOGIC; --CLK de 1Hz
           T5 : out STD_LOGIC;
           Q5 : out STD_LOGIC_VECTOR (2 downto 0));
end TIMER_PRE;

architecture Behavioral of TIMER_PRE is
     signal count : STD_LOGIC_VECTOR(2 downto 0) := "000";
begin

process(CLK, RESET5)
    begin
        if RESET5 = '1' then
            count <= "000";
            T5 <= '0';
        elsif rising_edge(CLK) then
            if EN5 = '1' then
                if count = "100" then 
                    T5 <= '1';
                else
                    count <= count + 1;
                    T5 <= '0';
                end if;
            end if;
        end if;
    end process;
    
    Q5 <= count;

end Behavioral;
