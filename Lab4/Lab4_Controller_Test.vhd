library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity Lab4_Controller_Test is 
end entity Lab4_Controller_Test; 
architecture my_test of Lab4_Controller_Test is     
signal t_clk, t_Load, t_Start: std_logic  := '0';
signal t_Data_In: std_logic_vector(15 downto 0) := conv_std_logic_vector(0,16);
signal t_Data_Out0, t_Data_Out1, t_Data_Out2, t_Data_Out3 : std_logic_vector(3 downto 0)  := "0000";
signal t_Time_Out: std_logic := '0';
     
component Lab4_Controller is
port(
	Clock, Load, Start   : in std_logic;
	Data_In 				 : in std_logic_vector(15 downto 0);
	Data_Out0			 : out std_logic_vector(3 downto 0);
	Data_Out1			 : out std_logic_vector(3 downto 0);
	Data_Out2			 : out std_logic_vector(3 downto 0);
	Data_Out3			 : out std_logic_vector(3 downto 0);
	Time_Out				 : out std_logic
);
end component;

begin

DUT: Lab4_Controller port map (t_clk, t_Load, t_Start, t_Data_In, t_Data_Out0, t_Data_Out1, t_Data_Out2, t_Data_Out3, t_Time_Out);
-- Initialization process (code that executes only once). 
init: process      
begin
	-- reset pulse        
	t_Load <= '0', '1' after 100 ns, '0' after 110 ns, '1' after 50000 ns, '0' after 50010 ns;
	t_Start <= '0', '1' after 10 ns, '0' after 40 ns, '1' after 120 ns, '0' after 130 ns, '1' after 50020 ns, '0' after 50030 ns;
	t_Data_In <= "0000000000000000", "0100010001000101" after 20 ns, "0011010001000101" after 20000 ns;
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
end architecture my_test;