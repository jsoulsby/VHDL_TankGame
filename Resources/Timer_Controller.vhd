library IEEE;
use IEEE.std_logic_1164.all;

entity Timer_Controller is
	port( 
	Clock				    : in std_logic;
	Start					 : in std_logic_vector (2 downto 0);
	Data_Out0			 : out std_logic_vector(3 downto 0);
	Data_Out1			 : out std_logic_vector(3 downto 0)
); end Timer_Controller;
			
architecture behaviour of Timer_Controller is
	signal Started: std_logic;
	signal Enabled1: std_logic;
	signal Q_Out_Seconds_Ones: std_logic_vector (3 downto 0) := "0000";	
	signal Q_Out_Seconds_Tens: std_logic_vector (3 downto 0) := "0000";
	signal Reset_All: std_logic;
	signal mode_latch: std_logic_vector(2 downto 0) := "000";
	-- Component counter
	component BCD_Counter10 is
		port(	
			Clk, Enable, Reset : in std_logic;
			Q : out std_logic_vector(3 downto 0));
	end component BCD_Counter10;
	
	component BCD_Counter1 is
		port(	
			Clk, Enable, Reset : in std_logic;
			Q : out std_logic_vector(3 downto 0));
	end component BCD_Counter1;
begin
	-- Declare port mapping
	-- C1 counts the first counter
	S1: 	BCD_Counter10
		port map(Clk => Clock, Enable => Enabled1, Reset => Reset_All, Q => Q_Out_Seconds_Tens);
	
	-- C2 counts the second counter
	S2: 	BCD_Counter1
		port map(Clk => Clock, Enable => Started, Reset => Reset_All, Q => Q_Out_Seconds_Ones);

	-- Counter logic
	process (clock)
		begin
			if (clock'event and clock = '1') then
				mode_latch <= start;
				if (mode_latch /= start) then
					Reset_All <= '1';
				else
					Reset_All <= '0';
				end if;
			end if;
	end process;
	Enabled1 <= '1' when (Q_Out_Seconds_Ones = "0000") else '0';
	Data_Out1 <= Q_Out_Seconds_Tens;
	Data_Out0 <= Q_Out_Seconds_Ones;			
	Started <= '1' when (Start = "010") or (Start = "011") else '0';
end architecture behaviour;