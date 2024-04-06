library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;

entity sobel_edge_detector is
	generic(
				WIDTH : integer := 64;
				HEIGHT : integer := 64);
	port(
				i_start : in std_logic;
				i_clk : in std_logic;
				o_ready : out std_logic := '0');
end sobel_edge_detector;

architecture Behavioral of sobel_edge_detector is

type states is (waiting_for_signal, read_file, calculate_edges, output_ready);
signal pr_state, nx_state : states := waiting_for_signal;

type img_matrix is array(0 to HEIGHT + 1, 0 to WIDTH + 1) of integer range 0 to 255;
type kernel_matrix is array(0 to 2, 0 to 2) of integer range -2 to +2;
begin
	
	lower_case: process(i_clk)
	begin
		if rising_edge(i_clk) then 
			pr_state <= nx_state;
		end if;
	end process lower_case;
	
	upper_case: process (pr_state, i_start)
	file img_file : text;
	file res_file : text;
	variable input_data: integer range 0 to 255;
	variable row : line;
	variable org_img : img_matrix;
	variable res_img : img_matrix;
	variable sum, Gx, Gy : integer;
	constant row_kernel : kernel_matrix := (
											(-1, 0, 1),
											(-2, 0, 2),
											(-1, 0, 1)
											);
	constant column_kernel : kernel_matrix := (
											(1, 2, 1),
											(0, 0, 0),
											(-1, -2, -1)
											);
	begin
		case pr_state is
			when waiting_for_signal =>
							o_ready <= '0';
							if rising_edge(i_start) then 
								nx_state <= read_file;
							end if;
			when read_file =>
							org_img := (others => (others => 0));
							file_open(img_file, "img.txt", read_mode);
							for i in 1 to HEIGHT loop
								for j in 1 to WIDTH loop
									readline(img_file, row);
									read(row, input_data);
									org_img(i, j) := input_data;
								end loop;
							end loop;
							file_close(img_file);
							nx_state <= calculate_edges;
			when calculate_edges =>
							for i in 1 to HEIGHT loop
								for j in 1 to WIDTH loop
									sum := 0;
									-- row convolution
									Gx := 0;
									for m in 0 to 2 loop
										for n in 0 to 2 loop
											Gx := Gx + (row_kernel(m, n) * org_img(i + m - 1, j + n - 1)); 
										end loop;
									end loop;
									-- column convolution
									Gy := 0;
									for m in 0 to 2 loop
										for n in 0 to 2 loop
											Gy := Gy + (column_kernel(m, n) * org_img(i + m - 1, j + n - 1)); 
										end loop;
									end loop;
									sum := abs(Gx) + abs(Gy);
									sum := sum / 9; --normalize
									res_img(i, j) := sum;
								end loop;
							end loop;
							nx_state <= output_ready;
			when output_ready =>
							file_open(res_file, "result.txt", write_mode);
							for i in 1 to HEIGHT loop
								for j in 1 to WIDTH loop
									write(row, res_img(i, j));
									writeline(res_file, row);
								end loop;
							end loop;
							file_close(res_file);
							o_ready <= '1';
							nx_state <= waiting_for_signal;
		end case;
	end process upper_case;

end Behavioral;

