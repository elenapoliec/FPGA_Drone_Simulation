library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.COORDONATE.all; 

entity ROM_COORDONATE is
    Port ( 
        ADDR : in  STD_LOGIC_VECTOR(6 downto 0); 
        DATA_OUT : out coord_type                 
    );
end ROM_COORDONATE;

architecture Behavioral of ROM_COORDONATE is

    -- initializare ROM
    function init_traseu return traseu_array is
        variable tmp : traseu_array;
    begin
        
        for i in 0 to 99 loop
            tmp(i) := (minute => 0, secunde => 0);
        end loop;

        
-- start = 25:13
-- pas = 22 secunde (22m)

tmp(0)  := (25,13);
tmp(1)  := (25,13);
tmp(2)  := (26,13);
tmp(3)  := (26,13);
tmp(4)  := (27,13);
tmp(5)  := (27,13);
tmp(6)  := (28,13);
tmp(7)  := (28,13);
tmp(8)  := (29,13);
tmp(9)  := (29,13);

tmp(10) := (30,13);
tmp(11) := (30,13);
tmp(12) := (31,13);
tmp(13) := (31,13);
tmp(14) := (32,13);
tmp(15) := (32,13);
tmp(16) := (33,13);
tmp(17) := (33,13);
tmp(18) := (34,13);
tmp(19) := (34,13);

tmp(20) := (35,13);
tmp(21) := (35,13);
tmp(22) := (36,13);
tmp(23) := (36,13);
tmp(24) := (37,13);
tmp(25) := (37,13);
tmp(26) := (38,13);
tmp(27) := (38,13);
tmp(28) := (39,13);
tmp(29) := (39,13);

tmp(30) := (40,13);
tmp(31) := (40,13);
tmp(32) := (41,13);
tmp(33) := (41,13);
tmp(34) := (42,13);
tmp(35) := (42,13);
tmp(36) := (43,13);
tmp(37) := (43,13);
tmp(38) := (44,13);
tmp(39) := (44,13);

tmp(40) := (45,13);
tmp(41) := (45,13);
tmp(42) := (46,13);
tmp(43) := (46,13);
tmp(44) := (47,13);
tmp(45) := (47,13);
tmp(46) := (48,13);
tmp(47) := (48,13);
tmp(48) := (49,13);
tmp(49) := (49,13);

tmp(50) := (50,13);
tmp(51) := (50,13);
tmp(52) := (51,13);
tmp(53) := (51,13);
tmp(54) := (52,13);
tmp(55) := (52,13);
tmp(56) := (53,13);
tmp(57) := (53,13);
tmp(58) := (54,13);
tmp(59) := (54,13);

tmp(60) := (55,14);
tmp(61) := (55,14);
tmp(62) := (56,14);
tmp(63) := (56,14);
tmp(64) := (57,14);
tmp(65) := (57,14);
tmp(66) := (58,14);
tmp(67) := (58,14);
tmp(68) := (59,14);
tmp(69) := (59,14);

tmp(70) := (60,14);
tmp(71) := (60,14);
tmp(72) := (60,15);
tmp(73) := (60,15);
tmp(74) := (60,15);
tmp(75) := (61,15);
tmp(76) := (61,15);
tmp(77) := (61,15);
tmp(78) := (61,16);
tmp(79) := (61,16);

tmp(80) := (61,16);
tmp(81) := (61,17);
tmp(82) := (61,17);
tmp(83) := (61,18);
tmp(84) := (61,18);
tmp(85) := (61,19);
tmp(86) := (61,19);
tmp(87) := (61,20);
tmp(88) := (61,20);
tmp(89) := (61,21);

tmp(90) := (61,21);
tmp(91) := (61,22);
tmp(92) := (61,22);
tmp(93) := (61,23);
tmp(94) := (61,23);
tmp(95) := (61,24);
tmp(96) := (61,24);
tmp(97) := (61,25);
tmp(98) := (61,26);
tmp(99) := (61,27);
        
        return tmp;
    end function;

    --constata care reprezinta memoria ROM
    constant memorie_puncte : traseu_array := init_traseu;

begin

    process(ADDR)
        variable idx : integer;
    begin
  
        --convertesc adresa din vector in intreg pt a accesa vectorul
        idx := to_integer(unsigned(ADDR));
        
        -- protectie ca sa nu depasesc 99
        if idx <= 99 then
            DATA_OUT <= memorie_puncte(idx);
        else
            DATA_OUT <= memorie_puncte(99); -- inapoi la ultimul punct
        end if;
    end process;

end Behavioral;