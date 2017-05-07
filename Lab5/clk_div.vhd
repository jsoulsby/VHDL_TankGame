library IEEE;
use IEEE.std_logic_1164.all;

entity clk_div is
port (clk1 : in std_logic;
       clk : out std_logic;
		 clkhalf : out std_logic
     );
end clk_div;

architecture Behavioral of clk_div is

signal count : integer :=1;
signal count2: integer :=1;
signal clktemp : std_logic :='0';
signal clktemp2: std_logic :='0';

begin
 --clk generation.For 50 MHz clock this generates 1 Hz clock.
process(clk1) 
	begin
		if(clk1'event and clk1='1') then
			count <=count+1;
			count2<=count2+1;
			if(count = 25000000) then
				clktemp <= not clktemp;
				count <=1;
			end if;			
			if(count2 = 50000000) then
				clktemp2 <= not clktemp2;
				count2 <=1;
			end if;
		end if;
end process;
clk <= clktemp;
clkhalf <= clktemp2;
end Behavioral;