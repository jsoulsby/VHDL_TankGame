			-- Bouncing Ball Video 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
LIBRARY lpm;
USE lpm.lpm_components.ALL;

PACKAGE de0core IS
	COMPONENT vga_sync
 		PORT(clock_25Mhz, red, green, blue	: IN	STD_LOGIC;
         	red_out, green_out, blue_out	: OUT 	STD_LOGIC;
			horiz_sync_out, vert_sync_out	: OUT 	STD_LOGIC;
			pixel_row, pixel_column			: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
	END COMPONENT;
END de0core;

			-- Bouncing Ball Video 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_SIGNED.all;
LIBRARY work;
USE work.de0core.all;

ENTITY Tank IS
Generic(ADDR_WIDTH: integer := 12; DATA_WIDTH: integer := 1);

   PORT(SIGNAL Mouse_X_motion, Mouse_Y_motion, Clock 			: IN std_logic;
        SIGNAL Red,Green,Blue 			: OUT std_logic;
        SIGNAL Horiz_sync,Vert_sync		: OUT std_logic);		
END Tank;

architecture behavior of Tank is

			-- Video Display Signals   
SIGNAL Red_Data, Green_Data, Blue_Data, vert_sync_int,
		reset, Ball_on, Direction			: std_logic;
SIGNAL Size 								: std_logic_vector(10 DOWNTO 0);  
SIGNAL Tank_X_motion 						: std_logic_vector(10 DOWNTO 0);
SIGNAL Tank_Y_pos, Tank_X_pos				: std_logic_vector(10 DOWNTO 0);
SIGNAL pixel_row, pixel_column				: std_logic_vector(10 DOWNTO 0); 

BEGIN           
   SYNC: vga_sync
 		PORT MAP(clock_25Mhz => clock, 
				red => red_data, green => green_data, blue => blue_data,	
    	     	red_out => red, green_out => green, blue_out => blue,
			 	horiz_sync_out => horiz_sync, vert_sync_out => vert_sync_int,
			 	pixel_row => pixel_row, pixel_column => pixel_column);

Size <= CONV_STD_LOGIC_VECTOR(16,10);
Tank_Y_pos <= CONV_STD_LOGIC_VECTOR(420,10);

		-- need internal copy of vert_sync to read
vert_sync <= vert_sync_int;

		-- Colors for pixel data on video signal
Red_Data <=  '1';
		-- Turn off Green and Blue when displaying ball
Green_Data <= NOT Tank_on;
Blue_Data <=  NOT Tank_on;

RGB_Display: Process (Tank_X_pos, Tank_Y_pos, pixel_column, pixel_row, Size)
BEGIN
			-- Set Tank_on ='1' to display red Tank
 IF ('0' & Tank_X_pos <= pixel_column + Size) AND
 			-- compare positive numbers only
 	(Tank_X_pos + Size >= '0' & pixel_column) AND
 	('0' & Tank_Y_pos <= pixel_row + Size) AND
 	(Tank_Y_pos + Size >= '0' & pixel_row ) THEN
 		Tank_on <= '1';
 	ELSE
 		Tank_on <= '0';
END IF;
END process RGB_Display;


Move_Tank: process(mouse_cursor_column)
BEGIN
			-- Move Tank depends horizontally depends on mouse
			WAIT UNTIL vert_sync_int'event and vert_sync_int = '1';
			-- Stop on the edge of the screen
			IF ('0' & Tank_X_pos) >= CONV_STD_LOGIC_VECTOR(480,10) - Size THEN
				Tank_X_motion <= CONV_STD_LOGIC_VECTOR(0,10);
			ELSIF Tank_X_pos <= Size THEN
				Tank_X_motion <= Mouse_X_motion;
			END IF;
			-- Compute next tank x position
				Tank_X_pos <= Tank_X_pos + Tank_X_motion;
END process Move_Ball;


END behavior;

