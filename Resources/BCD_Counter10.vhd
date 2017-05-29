library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity BCD_Counter10 is
	port(Clk, Init, Enable : in std_logic;
	     Q : out std_logic_vector(3 downto 0));
end entity BCD_Counter10;

architecture beh of BCD_Counter10 is
signal s_Q : std_logic_vector(3 downto 0) := "0110";
begin
	process (Clk)
		begin
		if rising_edge(Clk) then	
			if Enable = '0' then
				s_Q <= s_Q;
			elsif (Init = '1') then
					s_Q <= "0110";			
			elsif s_Q = "0000" then
					s_Q <= "0110";
				else
					s_Q <= s_Q - 1;
				end if;		
		end if;
	end process;
	Q <= s_Q;
end architecture beh;	