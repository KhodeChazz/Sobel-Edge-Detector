library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity simbug is
end simbug;

architecture Behavioral of simbug is
signal clk : std_logic;
signal test : integer range 0 to 10;
begin
	process(clk)
	begin
		if rising_edge(clk) then 
			test <= test + 1;
			if test = 10 then
				test <= 0;
			end if;
		end if;
	end process;

end Behavioral;

