library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity Lab5_Test is 
end entity Lab5_Test; 
architecture my_test of Lab5_Test is     
signal t_clk, t_clkhalf, t_Start, t_Start1: std_logic  := '0';
signal t_Data_Out0, t_Data_Out1: std_logic_vector(3 downto 0)  := "0000";
signal t_Ring_Out: std_logic_vector(7 downto 0) := "00000000";
     
component Lab5_Controller is
port(
	Clock, Clockhalf, Start, Start1   : in std_logic;
	Data_Out0			 : out std_logic_vector(3 downto 0);
	Data_Out1			 : out std_logic_vector(3 downto 0);
	Ring_Out			 : out std_logic_vector(7 downto 0)
);
end component;

begin

DUT: Lab5_Controller port map (t_clk, t_clkhalf, t_Start, t_Start1, t_Data_Out0, t_Data_Out1, t_Ring_Out);
-- Initialization process (code that executes only once). 
init: process      
begin
	-- reset pulse        
	t_Start <= '1', '0' after 100 ns;
	t_Start1 <= '1', '0' after 200 ns;
	wait;
end process init;
-- clock generation
clk_gen: process
begin
    t_clk <= '1';
    wait for 5 ns;
    t_clk <= '0';
	wait for 5 ns;
end process clk_gen;
clk_gen2: process
begin
	t_clkhalf <= '1';
	wait for 10 ns;
	t_clkhalf <= '0';
	wait for 10 ns;
end process clk_gen2;
end architecture my_test;