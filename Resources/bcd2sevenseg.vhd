library ieee ;
use ieee.std_logic_1164.all;
--Standard binary to seven segment converter,
entity bcd2sevenseg is
port(
	bcd_in:				in		std_logic_vector (3 downto 0);
	seven_seg:			out	std_logic_vector (6 downto 0)
); end bcd2sevenseg;

architecture behaviour of bcd2sevenseg is
	signal seg_temp:	std_logic_vector (6 downto 0);
begin    
	--bin_temp <= bin_in3&bin_in2&bin_in1&bin_in0;
	with bcd_in select
		seg_temp <=
			"1000000" when "0000", --0
			"1111001" when "0001", --1
			"0100100" when "0010", --2
			"0110000" when "0011", --3
			"0011001" when "0100", --4
			"0010010" when "0101", --5
			"0000010" when "0110", --6
			"1111000" when "0111", --7
			"0000000" when "1000", --8
			"0011000" when "1001", --9
--			"0001000" when "1010", --a
--			"0000011" when "1011", --b
--			"1000110" when "1100", --c
--			"0100001" when "1101", --d
--			"0000100" when "1110", --e
--			"0001110" when "1111", --f
			"1111111" when others; -- should not happen
	
	seven_seg <= seg_temp;
	
end behaviour;	
