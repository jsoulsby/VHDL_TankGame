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
			Player_Lose:	in std_logic;
			gamescore100:  in std_logic_vector (3 downto 0);
			gamescore10:   in std_logic_vector (3 downto 0);
			gamescore1:   in std_logic_vector (3 downto 0);
			-- 0 is training mode, 9 is game failed, 10 is idle start screen
			Mode:          out std_logic_vector (2 downto 0)
);
  
End FSM;
architecture behaviour of FSM is
Type state_type is (idle,level0,level1,level2,win,lose);
Signal y: state_type := idle;
begin
  process(clk,reset)
  begin
    if (Reset = '0') then
	   y <= idle; 
	 elsif (Quit = '0') then
	   y <= win;
	 elsif(SW0 = '1') then
	   y <= level0;
	 elsif(SW1 = '1') then
	   y <= level1;
	 elsif(SW2 = '1') then
	   y <= level2;
	 elsif (rising_edge(clk)) then
	   case y is 
	     when idle =>
	       Mode <= "000";
		    if (right_click = '1') then
		      y <= level1;
		    elsif (SW0 = '1') then
			   y <= level0;
			 end if;
	     when level0 =>
		    Mode <= "001";
		  when level1 =>
		    mode <= "010";
		    if (gamescore10 >= 1) then
			   y <= level2;
			 elsif ((leveltime10 = "0000" and leveltime1 = "0000") or Player_Lose = '1') then
			   y <= lose;
			 end if;
		  when level2 =>
			mode <= "011";
			 if (gamescore10 >= 1 and gamescore1 >= 5) then
			   y <= win; 
			elsif ((leveltime10 = "0000" and leveltime1 = "0000") or Player_Lose = '1') then
				y <= lose;
			 end if;
		  when lose =>
		    mode <= "100";
				if (left_click = '1') then
			   y <= idle;
			 end if;
		  when win =>
		      mode <= "101";
				if (left_click = '1') then
		        y <= idle;
				end if;
		  end case;
	 end if;
  end process;

end behaviour; 


		
	   
		
		
	 
    
		
		