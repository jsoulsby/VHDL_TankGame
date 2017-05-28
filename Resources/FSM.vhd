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
		   Quit:         in std_logic;
			leveltime:     in integer;
			right_click:   in std_logic;
         left_click:    in std_logic;
			-- slide switch 
			SW0:           in std_logic;
			--sw1
		   SW1:           in std_logic;
			--sw1
			SW2:           in std_logic;
			Score:         in std_logic_vector (3 downto 0);
			Enable:        out std_logic;
			-- 0 is traning mode, 9 is game failed, 10 is idle start screen
			Mode:          out integer
);
  
End FSM;

Architecture behav of FSM is

Type state_type is (idle,level0,level1,level2,wingame,gamefailed);
Signal y: state_type;
 
begin
  process(clk,reset)
  begin
    if (Reset = '0') then
	   y <= idle; 
	 elsif(SW0 = '1') then
	   y <= level0;
	 elsif(SW1 = '1') then
	   y <= level1;
	 elsif(SW2 = '1') then
	   y <= level2;
	 elsif (Quit = '0') then
	   y <= wingame;
	 elsif (rising_edge(clk)) then
	   case y is 
	     when idle =>
	       Mode <= 10;
		    if (left_click = '1') then
		      y <= level1;
		    elsif (right_click = '1') then
			   y <= level0;
			 end if;
	     when level0 =>
		    Mode <= 0;
		  when level1 =>
		    mode <= 1;
		    if (score > 10) then
			   y <= level2;
			 elsif (score <= 10 and leveltime = 0) then
			   y <= gamefailed;
			 end if;
		  when level2 =>
		    mode <= 2;
			 if (score > 50) then
			   y <= idle; 
			 end if;
		  when gamefailed =>
		    mode <= 9;
			 if (right_click = '1' or left_click = '1') then
			   y <= idle;
			 end if;
		  when wingame =>
		      mode <= 10;
				if (right_click = '1' or left_click = '1') then
		        y <= idle;
				end if;
		  end case;
	 end if;
  end process;
end behav; 


		
	   
		
		
	 
    
		
		