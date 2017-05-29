library IEEE;
use IEEE.std_logic_1164.all;

entity Timer_Controller is
	port( 
	Clock              : in std_logic;
	Mode					 : in std_logic_vector(2 downto 0);
	Data_Out0			 : out std_logic_vector(3 downto 0);
	Data_Out1			 : out std_logic_vector(3 downto 0)
); end Timer_Controller;
			
architecture behaviour of Timer_Controller is
	signal Started: std_logic;
	signal Reset0: std_logic;
	signal Reset1: std_logic;
	signal Enabled0: std_logic;
	signal Enabled1: std_logic;
	signal Q_Out_Seconds_Ones: std_logic_vector (3 downto 0) := "0110";	
	signal Q_Out_Seconds_Tens: std_logic_vector (3 downto 0) := "0000";	
	signal Loaded_Value: std_logic_vector(7 downto 0) := "00000000";
	signal Reset_All: std_logic;
	signal Start: std_logic;
	
	-- Component counter
	component BCD_Counter is
		port(	
			Clk, Init, Enable : in std_logic;
			Q : out std_logic_vector(3 downto 0));
	end component BCD_Counter;
	
		component BCD_Counter10 is
		port(	
			Clk, Init, Enable : in std_logic;
			Q : out std_logic_vector(3 downto 0));
	end component BCD_Counter10;
	
begin
	-- Declare port mapping
	-- C1 counts the ones seconds
	S1: 	BCD_Counter
		port map(Clk => Clock, Init => Reset0, Enable => Enabled0,
				Q => Q_Out_Seconds_Ones);
	
	-- C2 counts the tens seconds
	S2: 	BCD_Counter10
		port map(Clk => Clock, Init => Reset1, Enable => Enabled1,
					Q => Q_Out_Seconds_Tens);
	-- Counter logic
	Enabled0 <= '1' when (Started = '1') or Reset_All = '1' else '0';
	Enabled1 <= '1' when (Q_Out_Seconds_Ones = "1001") or Reset_All = '1' else '0';
	
	Reset0 <= '1' when Start = '1' or Reset_All = '1' else '0';
	Reset1 <= '1' when Start = '1' or Reset_All = '1' else '0';
	
	Start <= '1' when Mode = "010" or Mode = "011" else '0';
	
	process (Clock)
		begin
		if rising_edge(Clock) then
			if (Start = '1') then
				Started <= '1';
				Reset_All <= '0';
			end if;

			if (Q_Out_Seconds_Ones = Loaded_Value(3 downto 0)
			and  Q_Out_Seconds_Tens = Loaded_Value(7 downto 4)) then
				Started <= '0';
				Reset_All <= '1';
			end if;				
		end if;
	end process;
			Data_Out0 <= Q_Out_Seconds_Ones;
			Data_Out1 <= Q_Out_Seconds_Tens;
end architecture behaviour;