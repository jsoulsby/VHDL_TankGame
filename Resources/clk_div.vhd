library IEEE;
use IEEE.std_logic_1164.all;
--50Mhz -> 25Mhz clock divider (50Mhz is provided by the DE0 board)
entity clk_div is
port (clk1 : in std_logic;
       clk : out std_logic
     );
end clk_div;

architecture Behavioral of clk_div is

signal count : integer :=1;
signal clktemp : std_logic :='0';

begin

process(clk1) 
	begin
		if(clk1'event and clk1='1') then
			count <=count+1;
			if(count = 2) then
				clktemp <= not clktemp; --Generates clock at half the speed of input (i.e. 50 -> 25)
				count <= 1;
			end if;
			clk <= clktemp;
		end if;
end process;
end Behavioral;