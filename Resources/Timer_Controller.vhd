library IEEE;
use IEEE.std_logic_1164.all;

entity Timer_Controller is
	port( 
	Clock, Start	    : in std_logic;
	Data_Out0			 : out std_logic_vector(3 downto 0);
	Data_Out1			 : out std_logic_vector(3 downto 0)
); end Timer_Controller;
			
architecture behaviour of Timer_Controller is
	signal Enabled1: std_logic;
	signal Q_Out_Seconds_Ones: std_logic_vector (3 downto 0) := "0000";	
	signal Q_Out_Seconds_Tens: std_logic_vector (3 downto 0) := "0000";
	signal Reset_All: std_logic;
	-- Component counter
	component BCD_Counter is
		port(	
			Clk, Enable : in std_logic;
			Q : out std_logic_vector(3 downto 0));
	end component BCD_Counter;
	
begin
	-- Declare port mapping
	-- C1 counts the first counter
	S1: 	BCD_Counter
		port map(Clk => Clock, Enable => Start,
				Q => Q_Out_Seconds_Ones);
	
	-- C2 counts the second counter
	S2: 	BCD_Counter
		port map(Clk => Clock, Enable => Enabled1,
					Q => Q_Out_Seconds_Tens);

	-- Counter logic
	Enabled1 <= '0' when (Q_Out_Seconds_Ones = "0000") else '1';
	Data_Out0 <= Q_Out_Seconds_Ones;
	Data_Out1 <= Q_Out_Seconds_Tens;			

end architecture behaviour;