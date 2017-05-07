library IEEE;
use IEEE.std_logic_1164.all;

entity Ring_Counter is
	port(Clk, Enable : in std_logic;
	     Q : out std_logic_vector(7 downto 0));
end entity Ring_Counter;

architecture beh of Ring_Counter is
begin
	process (Clk)
		variable V_Count : std_logic_vector(7 downto 0) := "00000001";
		begin
			if rising_edge(Clk) then	
				if (Enable = '0') then				
					V_Count := V_Count(6 downto 0) & V_Count(7);
				end if;
				Q <= V_Count;
			end if;
	end process;
end architecture beh;	