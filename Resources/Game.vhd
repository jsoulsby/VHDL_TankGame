LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
LIBRARY work;
USE work.de0core.all;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

ENTITY Game IS
   PORT(
		Clock 																: IN std_logic;
	   Mouse_X_motion, Mouse_Y_motion								: IN std_logic_vector(9 DOWNTO 0);
      Red, Green, Blue													: OUT std_logic;
      Horiz_sync,Vert_sync												: OUT std_logic);		
   END Game;

ARCHITECTURE behaviour of game is
	
			-- Video Display Signals   
	SIGNAL Red_Data, Green_Data, Blue_Data, vert_sync_int,
		reset, Ball_on, Direction			: std_logic;
	SIGNAL Size 								: std_logic_vector(9 DOWNTO 0);  
	SIGNAL Ball_X_motion						:	std_logic_vector(9 DOWNTO 0);
	SIGNAL Ball_Y_pos, Ball_X_pos				: std_logic_vector(9 DOWNTO 0);
	SIGNAL pixel_row, pixel_column				: std_logic_vector(9 DOWNTO 0); 

		--Add VGA_SYNC component
	BEGIN

				
END behaviour;
