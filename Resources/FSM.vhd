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
		   Quit:          in std_logic;
			leveltime1:    in std_logic_vector(3 DOWNTO 0);
			leveltime10:   in std_logic_vector(3 DOWNTO 0);
			right_click:   in std_logic;
         left_click:    in std_logic;
			-- slide switch 
			SW0:           in std_logic;
			--sw1
		   SW1:           in std_logic;
			--sw1
			SW2:           in std_logic;
			gamescore100:  in std_logic_vector (3 downto 0);
			gamescore10:   in std_logic_vector (3 downto 0);
			gamescore1:   in std_logic_vector (3 downto 0);
			Enable:        out std_logic;
			-- 0 is training mode, 9 is game failed, 10 is idle start screen
			Mode:          out std_logic_vector (2 downto 0)
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
	       Mode <= "000";
		    if (left_click = '1') then
		      y <= level1;
		    elsif (right_click = '1') then
			   y <= level0;
			 end if;
	     when level0 =>
		    Mode <= "001";
		  when level1 =>
		    mode <= "010";
		    if (gamescore10 >= 1) then
			   y <= level2;
			 elsif (leveltime10 = "0000" and leveltime1 = "0000") then
			   y <= gamefailed;
			 end if;
		  when level2 =>
			mode <= "011";
			 if (gamescore10 >= 1 and gamescore1 >= 5) then
			   y <= wingame; 
			elsif (leveltime10 = "0000" and leveltime1 = "0000") then
				y <= gamefailed;
			 end if;
		  when gamefailed =>
		    mode <= "100";
			 if (right_click = '1' or left_click = '1') then
			   y <= idle;
			 end if;
		  when wingame =>
		      mode <= "101";
				if (right_click = '1' or left_click = '1') then
		        y <= idle;
				end if;
		  end case;
	 end if;
  end process;
end behav; 


		
	   
		
		
	 
    
		
		