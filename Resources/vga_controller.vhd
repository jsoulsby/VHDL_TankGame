LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY vga_controller IS
	PORT
	(
		--address							: 	IN STD_LOGIC_VECTOR (8 DOWNTO 0)
		sw0									:  IN STD_LOGIC;
		Mouse_X_Motion, Mouse_Y_Motion:	IN	STD_LOGIC_VECTOR (9 DOWNTO 0);
		mouse_left_click					:	IN STD_LOGIC;
		pixel_x								:	IN STD_LOGIC_VECTOR (9 DOWNTO 0);		
		pixel_y								:	IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		vert_sync_int						:	IN STD_LOGIC;
		clock									: 	IN STD_LOGIC;
		PB1, PB2								: 	IN STD_LOGIC;
		timer10_in, timer1_in			:  IN STD_LOGIC;
		red,green,blue						:	OUT STD_LOGIC
	);
END vga_controller;


ARCHITECTURE SYN OF vga_controller IS
	
	----------------------------------TEXT DISPLAY SIGNALS---------------------------------------
	SIGNAL rom_data															: STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL rom_mux_output													: STD_LOGIC;
	SIGNAL rom_address														: STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL text_on, timer_on												: STD_LOGIC;
	SIGNAL pix_y, pix_x														: UNSIGNED(9 DOWNTO 0);
	SIGNAL font_col, font_row												: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL char_address														: STD_LOGIC_VECTOR(5 DOWNTO 0);
	
	----------------------------------SCORE DISPLAY SIGNALS---------------------------------------	
	SIGNAL font_col_score, font_row_score								: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL char_address_score												: STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL gamescore1, gamescore10, gamescore100						: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL score_on															: STD_LOGIC;
	
	----------------------------------TIMER DISPLAY SIGNALS---------------------------------------	
	SIGNAL font_col_timer, font_row_timer								: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL char_address_timer												: STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL timer1, timer0													: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	SIGNAL time_on																: STD_LOGIC;
	
	-------------------------------- Enemy Tank Display Signals   -----------------------------------
	SIGNAL Enemy_Size 														: STD_LOGIC_VECTOR(9 DOWNTO 0);  
	SIGNAL Enemy_X_motion													: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL Enemy_X_motion_incrementer									: integer := 2;	
	SIGNAL Enemy_Y_pos, Enemy_X_pos										: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL EnemyTank_On														: STD_LOGIC;
	
	
	
	------------------------------- Player Tank Display Signals -----------------------------------
	SIGNAL Player_Size														: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL Player_X_motion													: STD_LOGIC_VECTOR(9 DOWNTO 0);	
	SIGNAL Player_X_Pos														: STD_LOGIC_VECTOR(9 DOWNTO 0);	
	SIGNAL Player_Y_Pos														: STD_LOGIC_VECTOR(9 DOWNTO 0);	
	SIGNAL PlayerTank_On														: STD_LOGIC;
	
	------------------------------- Bullet Signals --------------------------------------------------
	SIGNAL bullet_fired														: STD_LOGIC;
	SIGNAL bullet_on															: STD_LOGIC;
	SIGNAL bullet_motion														: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL bullet_X_Pos														: STD_LOGIC_VECTOR(9 DOWNTO 0);	
	SIGNAL bullet_Y_Pos														: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL bullet_Size														: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL font_col_bullet, font_row_bullet							: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL char_address_bullet												: STD_LOGIC_VECTOR(5 DOWNTO 0);
	
	--------------------------------------------------------------------------------------------------
	COMPONENT altsyncram
	GENERIC (
		address_aclr_a				: STRING;
		clock_enable_input_a		: STRING;
		clock_enable_output_a	: STRING;
		init_file					: STRING;
		intended_device_family	: STRING;
		lpm_hint						: STRING;
		lpm_type						: STRING;
		numwords_a					: NATURAL;
		operation_mode				: STRING;
		outdata_aclr_a				: STRING;
		outdata_reg_a				: STRING;
		widthad_a					: NATURAL;
		width_a						: NATURAL;
		width_byteena_a			: NATURAL
	);
	PORT (
		clock0		: IN STD_LOGIC ;
		address_a	: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		q_a			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	--rom_mux_output	<= sub_wire0(7 DOWNTO 0);
	pix_x <= UNSIGNED(pixel_x);
	pix_y <= UNSIGNED(pixel_y);
	
	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "tcgrom2.mif",
		intended_device_family => "Cyclone III",
		lpm_hint => "ENABLE_RUNTIME_MOD=NO",
		lpm_type => "altsyncram",
		numwords_a => 512,
		operation_mode => "ROM",
		outdata_aclr_a => "NONE",
		outdata_reg_a => "UNREGISTERED",
		widthad_a => 9,
		width_a => 8,
		width_byteena_a => 1
	)
	PORT MAP (
		clock0 => clock,
		address_a => rom_address,
		q_a => rom_data
	);

Score_Display: Process(pix_x, pix_y)
begin
	if pix_y(9 downto 3) = 1 and pix_x(9 downto 3) > 3 and pix_x(9 downto 3) < 13 then
		score_on <= '1';
	else
		score_on <= '0';
	end if;
	font_row_score <= STD_LOGIC_VECTOR(pix_y(2 downto 0));
	font_col_score <= STD_LOGIC_VECTOR(pix_x(2 downto 0));
	case pix_x(9 downto 3) is
		when "0000100" =>
			char_address_score <= "010011";  -- S (23)	(when at index 4)
		when "0000101" =>
			char_address_score <= "000011";	-- C (03)	(when at index 5)
		when "0000110" =>
			char_address_score <= "001111";	-- O (17)	(when at index 6)	 
		when "0000111" =>   	
			char_address_score <= "010010";	-- R (22)	(when at index 7)
		when "0001000" =>  		
			char_address_score <= "000101";	-- E (05)	(when at index 8)
		when "0001001" =>  		
			char_address_score <= "100000";	--   (40)   (when at index 9)	
		when "0001010" =>
			case gameScore100 is
				when "0000" => char_address_score <= "110000";
				when "0001" => char_address_score <= "110001";
				when "0010" => char_address_score <= "110010";
				when "0011" => char_address_score <= "110011";
				when "0100" => char_address_score <= "110100";
				when "0101" => char_address_score <= "110101";
				when "0110" => char_address_score <= "110110";
				when "0111" => char_address_score <= "110111";
				when "1000" => char_address_score <= "111000";
				when others => char_address_score <= "111001";
			end case;
		when "0001011" =>
			case gameScore10 is
				when "0000" => char_address_score <= "110000";
				when "0001" => char_address_score <= "110001";
				when "0010" => char_address_score <= "110010";
				when "0011" => char_address_score <= "110011";
				when "0100" => char_address_score <= "110100";
				when "0101" => char_address_score <= "110101";
				when "0110" => char_address_score <= "110110";
				when "0111" => char_address_score <= "110111";
				when "1000" => char_address_score <= "111000";
				when others => char_address_score <= "111001";
			end case;		
		when others =>
		case gameScore1 is
				when "0000" => char_address_score <= "110000";
				when "0001" => char_address_score <= "110001";
				when "0010" => char_address_score <= "110010";
				when "0011" => char_address_score <= "110011";
				when "0100" => char_address_score <= "110100";
				when "0101" => char_address_score <= "110101";
				when "0110" => char_address_score <= "110110";
				when "0111" => char_address_score <= "110111";
				when "1000" => char_address_score <= "111000";
				when others => char_address_score <= "111001";
		end case;	
	end case;	
end process;

Timer_Display: Process(pix_x, pix_y)
begin
	if pix_y(9 downto 3) = 1 and pix_x(9 downto 3) > 66 and pix_x(9 downto 3) < 74 then
		time_on <= '1';
	else
		time_on <= '0';
	end if;
	font_row_timer <= STD_LOGIC_VECTOR(pix_y(2 downto 0));
	font_col_timer <= STD_LOGIC_VECTOR(pix_x(2 downto 0));
	case pix_x(9 downto 3) is
		when "1000011" =>
			char_address_timer <= "010100";  -- T (24)	(when at index 67)
		when "1000100" =>
			char_address_timer <= "001001";	-- I (11)	(when at index 68)
		when "1000101" =>
			char_address_timer <= "001101";	-- M (15)	(when at index 69)	 
		when "1000110" =>   	
			char_address_timer <= "000101";	-- E (05)	(when at index 70)
		when "1000111" =>  		
			char_address_timer <= "100000";	--   (40)	(when at index 71)
		when "1001000" =>
		case timer1 is
				when "0000" => char_address_timer <= "110000";
				when "0001" => char_address_timer <= "110001";
				when "0010" => char_address_timer <= "110010";
				when "0011" => char_address_timer <= "110011";
				when "0100" => char_address_timer <= "110100";
				when "0101" => char_address_timer <= "110101";
				when "0110" => char_address_timer <= "110110";
				when "0111" => char_address_timer <= "110111";
				when "1000" => char_address_timer <= "111000";
				when others => char_address_timer <= "111001";
		end case;
		when "1001001" =>
			case timer0 is
				when "0000" => char_address_timer <= "110000";
				when "0001" => char_address_timer <= "110001";
				when "0010" => char_address_timer <= "110010";
				when "0011" => char_address_timer <= "110011";
				when "0100" => char_address_timer <= "110100";
				when "0101" => char_address_timer <= "110101";
				when "0110" => char_address_timer <= "110110";
				when "0111" => char_address_timer <= "110111";
				when "1000" => char_address_timer <= "111000";
				when others => char_address_timer <= "111001";
		end case;
		when others =>
			char_address_timer <= "100110";
	end case;	
end process;

	-------------------use bullet shape in mif file-----------
	char_address_bullet <= "111111"; -- swapped out 'F' for bullet shape in mif file (77)
	font_row_bullet <= STD_LOGIC_VECTOR(pix_y(2 downto 0));
	font_col_bullet <= STD_LOGIC_VECTOR(pix_x(2 downto 0));
	
	process(score_on, char_address_score, font_col_score, font_row_score, EnemyTank_On, PlayerTank_On, bullet_on)
	begin
	red <= '1';
	green <= '1';
	blue <= '1';	
	
	if PlayerTank_On = '1' then
		red  <= '1';
		green <= '0';
		blue <= '0';
	end if;
	if bullet_on = '1' then
		char_address <= char_address_bullet;
		font_row <= font_row_bullet;
		font_col <= font_col_bullet;
		if (rom_mux_output = '1') then
			red <= '1';
			green <= '0';
			blue <= '0';
		end if;
	end if;
	if EnemyTank_On = '1' then
		red <= '0';
		green <= '0';
		blue <= '1';
	end if;
	if score_on = '1' then
		char_address <= char_address_score;
		font_row <= font_row_score;
		font_col <= font_col_score;
		if rom_mux_output = '1' then
			red <= '0';
			green <= '0';
			blue <= '0';
		end if;
	end if;
	if time_on = '1' then
		char_address <= char_address_timer;
		font_row <= font_row_timer;
		font_col <= font_col_timer;
		if rom_mux_output = '1' then
			red <= '0';
			green <= '0';
			blue <= '0';
		end if;
	end if;
	end process;
	
	text_on <= score_on and time_on;
	rom_address <= char_address & font_row;
	rom_mux_output <= rom_data (CONV_INTEGER(NOT font_col(2 DOWNTO 0)));
	
	
-----------------ENEMY TANK DISPLAY AND PROCESSES-------------------------------	
	
Enemy_Size <= CONV_STD_LOGIC_VECTOR(8,10);	--ENEMY TANK SIZE HERE
Enemy_Y_pos <= CONV_STD_LOGIC_VECTOR(25,10);

RGB_Display_EnemyTank: Process (Enemy_X_pos, Enemy_Y_pos, pixel_y, pixel_x, Enemy_Size)
BEGIN
			-- Set EnemyTank_On ='1' to display ball
 IF ('0' & Enemy_X_pos <= '0' & pixel_x + Enemy_Size) AND
 			-- compare positive numbers only
 	('0' & Enemy_X_pos + Enemy_Size >= '0' & pixel_x) AND
 	('0' & Enemy_Y_pos <= '0' & pixel_y + Enemy_Size) AND
 	('0' & Enemy_Y_pos + Enemy_Size >= '0' & pixel_y ) THEN
 		EnemyTank_On <= '1';
 	ELSE
 		EnemyTank_On <= '0';
END IF;
END process RGB_Display_Enemytank;

Move_Enemy: process
BEGIN
			-- Move enemy once every vertical sync
	WAIT UNTIL vert_sync_int'event and vert_sync_int = '1';
			-- Bounce off left or right of screen
			IF ('0' & Enemy_X_pos) >= '0' & CONV_STD_LOGIC_VECTOR(639,10) - Enemy_Size THEN
				Enemy_X_motion <=  CONV_STD_LOGIC_VECTOR(-Enemy_X_motion_incrementer,10); -- negative 2
			ELSIF ('0' & Enemy_X_pos) <= Enemy_Size THEN
				Enemy_X_motion <= CONV_STD_LOGIC_VECTOR(Enemy_X_motion_incrementer,10);
			END IF;
			-- Compute next enemy Y position
			IF(PB1 = '0' OR PB2 = '0') then
				Enemy_X_pos <= Enemy_X_pos + Enemy_X_motion + Enemy_X_motion;
			ELSE
				Enemy_X_pos <= Enemy_X_pos + Enemy_X_motion;
			END IF;			
END process Move_Enemy;


--------------------------------- PLAYER TANK AND PROCESSES --------------------------------------

Player_Size <= CONV_STD_LOGIC_VECTOR(8,10);
Player_Y_pos <= CONV_STD_LOGIC_VECTOR(420,10);

RGB_Display_PlayerTank: Process (Player_X_Pos, Player_Y_Pos, pixel_y, pixel_x, Player_Size)
BEGIN
			-- Set Tank_on ='1' to display red Tank
 IF ('0' & Player_X_Pos <= '0' & pixel_x + Player_Size) AND
 			-- compare positive numbers only
 	('0' & Player_X_Pos + Player_Size >= '0' & pixel_x) AND
 	('0' & Player_Y_Pos <= '0' & pixel_y + Player_Size) AND
	('0' & Player_Y_Pos + Player_Size >= '0' & pixel_y ) THEN
 		PlayerTank_on <= '1';
  ELSE
 		PlayerTank_on <= '0';
  END IF;
END process RGB_Display_PlayerTank;


Move_Tank: process(Player_X_motion,vert_sync_int)
BEGIN
         -- Move Tank depends horizontally depends onmouse
			if(vert_sync_int'event and vert_sync_int = '1') then
			   if(sw0 = '1') then
				  Player_X_Pos <= CONV_STD_LOGIC_VECTOR(320,10);
			   else
			     Player_X_motion <= Mouse_X_motion;
			     -- Compute next tank x position
		        Player_X_pos <= Player_X_motion;
				end if;
			end if;
			
END process Move_Tank;

bullet_motion <= CONV_STD_LOGIC_VECTOR(10,10);
bullet_size	  <= CONV_STD_LOGIC_VECTOR(2, 10);
Tank_Shoot: process(vert_sync_int, bullet_motion, mouse_left_click, sw0)
BEGIN		
			if(vert_sync_int'event and vert_sync_int = '1') then
				if (sw0 = '1') then
					gameScore1 <= "0000";
					gameScore10 <= "0000";
					gameScore100 <= "0000";
					bullet_fired <= '0';
				else 
					if(bullet_fired = '0' and mouse_left_click = '1') then
							bullet_fired <= '1';
							bullet_Y_Pos <= CONV_STD_LOGIC_VECTOR(410, 10); --hard coded to be just above player tank
							bullet_X_Pos <= player_X_Pos;
					end if;
					--check if bullet hits enemy
					if (bullet_fired = '1') then
						IF ('0' & Enemy_X_Pos <= '0' & bullet_X_pos + Enemy_Size) AND
							('0' & Enemy_X_Pos + Enemy_Size >= '0' & bullet_X_pos) AND
							('0' & Enemy_Y_Pos <= '0' & bullet_Y_pos + Enemy_Size) AND
							('0' & Enemy_Y_Pos + Enemy_Size >= '0' & bullet_Y_Pos) THEN
							-------------------gamescore counter------------------------------------
							if gameScore1 = "1001" then
								Enemy_X_motion_incrementer <= Enemy_X_motion_incrementer + 1;
								if gameScore10 = "1001" then
									if gameScore100 = "1001" then
										gameScore100 <= "0000";
									else
										gameScore100 <= gameScore100 + 1;
									end if;
									gameScore10 <= "0000";
								else
									gameScore10 <= gameScore10 + 1;
								end if;
								gameScore1 <= "0000";
							else
								gamescore1 <= gameScore1 + 1;
							end if;
	
						----------------------------allow bullets to fire again----------------------
							bullet_fired <= '0';
						-------------------check if bullet misses enemy------------------------------
						ELSIF ('0' & bullet_Y_pos) <= '0' & bullet_Size THEN
							bullet_fired <= '0';
						ELSE
							-- Compute next bullet Y position
							bullet_Y_pos <= bullet_Y_Pos - bullet_motion;
						end if;
					end if;
				end if;
			end if;

END process Tank_Shoot;
			
RGB_Display_Bullet: process(bullet_X_Pos, bullet_Y_Pos, pixel_x, pixel_y)
BEGIN
	if (sw0 = '1') then
		bullet_on <= '0';
	else
		if(bullet_fired = '1') then
			IF ('0' & bullet_X_Pos <= '0' & pixel_x + bullet_Size) AND
					-- compare positive numbers only
				('0' & bullet_X_Pos + bullet_Size >= '0' & pixel_x) AND
				('0' & bullet_Y_Pos <= '0' & pixel_y + bullet_Size) AND
				('0' & bullet_Y_Pos + bullet_Size >= '0' & pixel_y ) THEN
				bullet_on <= '1';
			ELSE
				bullet_on <= '0';
			END IF;
		ELSE	
			bullet_on <= '0';
		END IF;
	end if;
END process RGB_Display_Bullet;
END SYN;