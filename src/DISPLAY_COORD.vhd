library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DISPLAY_COORD is
    Port(
        VAL : in INTEGER range 0 to 99;

        SEG_Z : out STD_LOGIC_VECTOR(6 downto 0);
        SEG_U : out STD_LOGIC_VECTOR(6 downto 0)
    );
end DISPLAY_COORD;

architecture Behavioral of DISPLAY_COORD is

    -- semnale BCD
    signal bcd_z : STD_LOGIC_VECTOR(3 downto 0);
    signal bcd_u : STD_LOGIC_VECTOR(3 downto 0);

begin

  
    -- Convertor BINAR -> BCD
    BCD1 : entity work.BIN_TO_BCD
    port map(
        BIN => VAL,
        ZECI => bcd_z,
        UNITATI => bcd_u
    );

    -- decoder 7 segmente pentru zeci
    D2 : entity work.DECO_7SEG
    port map(
        CIFRA => bcd_z,
        SEG => SEG_Z
    );

    -- decoder 7 segmente pentru unitati
    D3 : entity work.DECO_7SEG
    port map(
        CIFRA => bcd_u,
        SEG => SEG_U
    );

end Behavioral;