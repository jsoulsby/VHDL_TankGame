library IEEE;
use IEEE.std_logic_1164.all;
--50Mhz -> 25Mhz clock divider (50Mhz is provided by the DE0 board)
entity clk_div is
port (clk_in : in std_logic;
       clk_halved : out std_logic
     );
end clk_div;

architecture Behavioral of clk_div is

signal clktemp : std_logic :='0';

begin

process(clk_in) 
	begin
		if(clk_in'event and clk_in='1') then
				clktemp <= not clktemp; --Generates clock at half the speed of input (i.e. 50 -> 25)
			clk_halved <= clktemp;
		end if;
end process;
end Behavioral;