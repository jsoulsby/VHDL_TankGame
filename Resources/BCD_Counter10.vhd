library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity BCD_Counter10 is
	port(Clk, Enable : in std_logic;
	     Q : out std_logic_vector(3 downto 0));
end entity BCD_Counter10;

architecture beh of BCD_Counter10 is
signal s_Q : std_logic_vector(3 downto 0) := "0110";
signal Enabled: std_logic := '0';
signal Counter : integer := 25000000;
begin
	process (Clk)
		begin
		if (rising_edge(Clk)) then
			if (Enable = '1') then		
				if (Counter = 25000000) then			
					if (s_Q = "0000") then
						s_Q <= "0101";
					else
						s_Q <= s_Q - 1;
					end if;
					Counter <= 0;
				else
					Counter <= Counter + 1;
				end if;
			end if;
		end if;
		Q <= s_Q;
	end process;
end architecture beh;	