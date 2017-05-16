LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY char_rom IS
	PORT
	(
		--address			: 	IN STD_LOGIC_VECTOR (8 DOWNTO 0)
		pixel_x				:	IN STD_LOGIC_VECTOR (9 DOWNTO 0);		
		pixel_y				:	IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock					: 	IN STD_LOGIC ;
		red,green,blue		:	OUT STD_LOGIC
	);
END char_rom;


ARCHITECTURE SYN OF char_rom IS

	SIGNAL rom_data															: STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL rom_mux_output													: STD_LOGIC;
	SIGNAL rom_address														: STD_LOGIC_VECTOR (8 DOWNTO 0);
	SIGNAL text_on, score_on												: STD_LOGIC;
	SIGNAL pix_y, pix_x														: UNSIGNED(9 DOWNTO 0);
	SIGNAL font_col, font_col_score, font_row, font_row_score	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL char_address, char_address_score							: STD_LOGIC_VECTOR(5 downto 0);

	COMPONENT altsyncram
	GENERIC (
		address_aclr_a			: STRING;
		clock_enable_input_a	: STRING;
		clock_enable_output_a	: STRING;
		init_file				: STRING;
		intended_device_family	: STRING;
		lpm_hint				: STRING;
		lpm_type				: STRING;
		numwords_a				: NATURAL;
		operation_mode			: STRING;
		outdata_aclr_a			: STRING;
		outdata_reg_a			: STRING;
		widthad_a				: NATURAL;
		width_a					: NATURAL;
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
	pix_x <= unsigned(pixel_x);
	pix_y <= unsigned(pixel_y);
	
	altsyncram_component : altsyncram
	GENERIC MAP (
		address_aclr_a => "NONE",
		clock_enable_input_a => "BYPASS",
		clock_enable_output_a => "BYPASS",
		init_file => "tcgrom.mif",
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
	
	score_on <= '1' when
		pix_y(9 downto 3) = 4
		and
		pix_x(9 downto 3) > 3
		and
		pix_x(9 downto 3) < 9
		else
		'0';
	font_row_score <= std_logic_vector(pix_y(2 downto 0));
	font_col_score <= std_logic_vector(pix_x(2 downto 0));
	with pix_x(9 downto 3) select
	char_address_score <=
	"010011" when "0000100",   -- S (23)
	"000011" when "0000101",   -- C (03)
	"001111"	when "0000110",   -- O (17)
	"010010" when "0000111",   -- R (22)	
	"000101" when others;   -- E (05)
	
	process(score_on, char_address_score, font_col_score, font_row_score)
	begin
	red <= '1';
	green <= '1';
	blue <= '1';	
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
	end process;
	text_on <= score_on;
	rom_address <= char_address & font_row;
	rom_mux_output <= rom_data (CONV_INTEGER(NOT font_col(2 DOWNTO 0)));
END SYN;