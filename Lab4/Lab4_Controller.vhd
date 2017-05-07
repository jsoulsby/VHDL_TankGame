library IEEE;
use IEEE.std_logic_1164.all;

entity Lab4_Controller is
	port( 
	Clock, Load, Start               : in std_logic;
	Data_In 			 : in std_logic_vector(15 downto 0);
	Data_Out0			 : out std_logic_vector(3 downto 0);
	Data_Out1			 : out std_logic_vector(3 downto 0);
	Data_Out2			 : out std_logic_vector(3 downto 0);
	Data_Out3			 : out std_logic_vector(3 downto 0);
	Time_Out			 : out std_logic
); end Lab4_Controller;
			
architecture behaviour of Lab4_Controller is
	signal Started: std_logic;
	signal Reset0: std_logic;
	signal Reset1: std_logic;
	signal Reset2: std_logic;
	signal Reset3: std_logic;
	signal Enabled0: std_logic;
	signal Enabled1: std_logic;
	signal Enabled2: std_logic;
	signal Enabled3: std_logic;
	signal Q_Out_Seconds_Ones: std_logic_vector (3 downto 0) := "0000";	
	signal Q_Out_Seconds_Tens: std_logic_vector (3 downto 0) := "0000";	
	signal Q_Out_Minutes_Ones: std_logic_vector (3 downto 0) := "0000";	
	signal Q_Out_Minutes_Tens: std_logic_vector (3 downto 0) := "0000";
	signal Loaded_Value: std_logic_vector(15 downto 0) := "0000000000000000";
	signal Reset_All: std_logic;
	
	-- Component counter
	component BCD_Counter is
		port(	
			Clk, Direction, Init, Enable : in std_logic;
			Q : out std_logic_vector(3 downto 0));
	end component BCD_Counter;
	
begin
	-- Declare port mapping
	-- C1 counts the ones seconds
	S1: 	BCD_Counter
		port map(Clk => Clock, Direction => '0', Init => Reset0, Enable => Enabled0,
				Q => Q_Out_Seconds_Ones);
	
	-- C2 counts the tens seconds
	S2: 	BCD_Counter
		port map(Clk => Clock, Direction => '0', Init => Reset1, Enable => Enabled1,
					Q => Q_Out_Seconds_Tens);
					
	-- M1 counts the ones minutes
	M1: 	BCD_Counter
		port map(Clk => Clock, Direction => '0', Init => Reset2, Enable => Enabled2,
				Q => Q_Out_Minutes_Ones);
	
	-- C2 counts the tens minutes
	M2: 	BCD_Counter
		port map(Clk => Clock, Direction => '0', Init => Reset3, Enable => Enabled3,
					Q => Q_Out_Minutes_Tens);
	
	-- Counter logic
	Enabled0 <= '1' when (Started = '1') or Reset_All = '1' else '0';
	Enabled1 <= '1' when (Q_Out_Seconds_Ones = "1001") or Reset_All = '1' else '0';
	Enabled2 <= '1' when (Q_Out_Seconds_Tens = "0101" and Q_Out_Seconds_Ones = "1000") or Reset_All = '1' else '0';
	Enabled3 <= '1' when (Q_Out_Minutes_Ones = "1001" and Q_Out_Seconds_Tens = "0101" and Q_Out_Seconds_Ones = "1000") or Reset_All = '1' else '0';
	
	Reset0 <= '1' when Start = '1' or Reset_All = '1' else '0';
	Reset1 <= '1' when Start = '1' or Reset_All = '1' else '0';
	Reset2 <= '1' when Start = '1' or Reset_All = '1' else '0';
	Reset3 <= '1' when (Q_Out_Minutes_Tens = "0101" and Q_Out_Minutes_Ones = "1001" and Q_Out_Seconds_Tens = "0101" and Q_Out_Seconds_Ones = "1000") or Reset_All = '1' or Start = '1' else '0';
	Loaded_Value <= Data_In when (Load = '1');
	
	process (Clock)
		begin
		if rising_edge(Clock) then
			if (Start = '1') then
				Started <= '1';
				Reset_All <= '0';
			end if;

			if (Q_Out_Seconds_Ones = Loaded_Value(3 downto 0)
			and  Q_Out_Seconds_Tens = Loaded_Value(7 downto 4)
			and  Q_Out_Minutes_Ones = Loaded_Value(11 downto 8)
			and  Q_Out_Minutes_Tens = Loaded_Value(15 downto 12)) then						  
				Time_Out <= '1';
				Started <= '0';
				Reset_All <= '1';
			else
				Time_Out <= '0';
			end if;
			
			
			
		end if;
	end process;
			Data_Out0 <= Q_Out_Seconds_Ones;
			Data_Out1 <= Q_Out_Seconds_Tens;
			Data_Out2 <= Q_Out_Minutes_Ones;
			Data_Out3 <= Q_Out_Minutes_Tens;

end architecture behaviour;