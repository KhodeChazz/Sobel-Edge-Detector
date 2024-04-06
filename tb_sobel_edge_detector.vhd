library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sobel_edge_detector is
end tb_sobel_edge_detector;

architecture Behavioral of tb_sobel_edge_detector is
component sobel_edge_detector is
	generic(
				WIDTH : integer := 64;
				HEIGHT : integer := 64);
	port(
				i_start : in std_logic;
				i_clk : in std_logic;
				o_ready : out std_logic := '0');
end component;
signal tb_start, tb_clk, tb_ready : std_logic := '0';

begin
	process
	begin	
			tb_clk <= '1';
			wait for 100ns;
			tb_clk <= '0';
			wait for 100ns;
	end process;
	
	process
	begin
		wait for 500ns;
		tb_start <= '1'; 
		wait for 100ns;
		tb_start <= '0';
		wait for 20us;
	end process;
	sobel: sobel_edge_detector generic map(612, 250) port map(tb_start, tb_clk, tb_ready);
end Behavioral;

