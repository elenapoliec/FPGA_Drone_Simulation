library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BIN_TO_BCD is
    Port (
        BIN      : in  integer range 0 to 99;
        ZECI     : out STD_LOGIC_VECTOR (3 downto 0);
        UNITATI  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end BIN_TO_BCD;

architecture Behavioral of BIN_TO_BCD is
begin

    process(BIN)
        variable z : integer;
        variable u : integer;
    begin

        z := BIN / 10;
        u := BIN mod 10;

        ZECI    <= std_logic_vector(to_unsigned(z, 4));
        UNITATI <= std_logic_vector(to_unsigned(u, 4));

    end process;

end Behavioral;