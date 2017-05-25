-- FSM

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
LIBRARY work;

Entity FSM is
  port ( clk:           in std_logic;
         --pb1
         Reset:         in std_logic;
			--pb2
		   Pause:         in std_logic;
			right_click:   in std_logic;
         left_click:    in std_logic;
			--sw0
			level2:        in std_logic;
			--sw1
			level3:        in std_logic;
			--Score: in std_logic_vector (3 downto 0);
			Enable:        out std_logic;
			Fire:          out std_logic;
			level:         out integer;
			displayidle:   out std_logic;
			Freeze:        out std_logic
  );
  
End FSM;

Architecture behav of FSM is

Type state_type is (idle,game,pausegame);
Signal y: state_type;

begin
  process(clk,reset)
  begin
    if (reset = '0') then
	   y <= idle; 
	 elsif (rising_edge(clk)) then
	   case y is 
	   when idle =>
	      displayidle <= '1';
		   if (right_click = '1' OR left_click = '1') then
		     y <= game; 
		   end if;
	   when game =>
		   if(left_click = '1' OR right_click = '1')then
			  Fire <= '1'; 
		     if (level2 = '1') then
			    level <= 2;
			  elsif (level3 = '1') then
			    level <= 3;
		     elsif (Pause = '1') then
			    y <= pausegame;
			  end if;
			end if;
		when pausegame =>
		  Freeze <= '1';
		end case;
	 end if;
	end process;
	
end behav; 


		
	   
		
		
	 
    
		
		