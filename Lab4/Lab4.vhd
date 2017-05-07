-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Full Version"
-- CREATED		"Thu Apr 06 17:00:17 2017"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Lab4 IS 
	PORT
	(
		Load :  IN  STD_LOGIC;
		Start :  IN  STD_LOGIC;
		clk_in :  IN  STD_LOGIC;
		Data_In :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		Time_Out :  OUT  STD_LOGIC;
		minute_out_0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		minutes_out_1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		second_out_0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		second_out_1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END Lab4;

ARCHITECTURE bdf_type OF Lab4 IS 

COMPONENT lab4_controller
	PORT(Clock : IN STD_LOGIC;
		 Load : IN STD_LOGIC;
		 Start : IN STD_LOGIC;
		 Data_In : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Time_Out : OUT STD_LOGIC;
		 Data_Out0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Data_Out1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Data_Out2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Data_Out3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bcd2sevenseg
	PORT(bcd_in0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 bcd_in1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 bcd_in2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 bcd_in3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seven_seg0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 seven_seg1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 seven_seg2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 seven_seg3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT clk_div
	PORT(clk1 : IN STD_LOGIC;
		 clk : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 



b2v_inst : lab4_controller
PORT MAP(Clock => SYNTHESIZED_WIRE_0,
		 Load => Load,
		 Start => Start,
		 Data_In => Data_In,
		 Time_Out => Time_Out,
		 Data_Out0 => SYNTHESIZED_WIRE_1,
		 Data_Out1 => SYNTHESIZED_WIRE_2,
		 Data_Out2 => SYNTHESIZED_WIRE_3,
		 Data_Out3 => SYNTHESIZED_WIRE_4);


b2v_inst2 : bcd2sevenseg
PORT MAP(bcd_in0 => SYNTHESIZED_WIRE_1,
		 bcd_in1 => SYNTHESIZED_WIRE_2,
		 bcd_in2 => SYNTHESIZED_WIRE_3,
		 bcd_in3 => SYNTHESIZED_WIRE_4,
		 seven_seg0 => second_out_0,
		 seven_seg1 => second_out_1,
		 seven_seg2 => minute_out_0,
		 seven_seg3 => minutes_out_1);


b2v_inst31 : clk_div
PORT MAP(clk1 => clk_in,
		 clk => SYNTHESIZED_WIRE_0);


END bdf_type;