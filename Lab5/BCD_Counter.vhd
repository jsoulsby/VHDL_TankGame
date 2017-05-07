library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity BCD_Counter is
	port(Clk, Enable : in std_logic;
	     Q : out std_logic_vector(3 downto 0));
end entity BCD_Counter;

architecture beh of BCD_Counter is
signal s_Q : std_logic_vector(3 downto 0) := "0000";
signal Enabled: std_logic := '0';
begin
	process (Clk)
		begin
		if (rising_edge(Clk)) then
			if (Enable = '0') then				
			if (s_Q = "0000") then
				s_Q <= "1111";
			else
				s_Q <= s_Q - 1;
			end if;
		end if;
		end if;
		Q <= s_Q;
	end process;
end architecture beh;	