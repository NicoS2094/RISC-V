-- 1. Participant First and Last Name: Nicolas Schmidt
-- 2. Participant First and Last Name: Jakob Krug


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_Package.all;

entity gen_register_tb is
end entity gen_register_tb;

architecture testbench of gen_register_tb is


  signal s_data_in : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
  signal s_data_out : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
  signal s_clk : std_logic := '0'; 
  signal s_rst : std_logic := '0';
 
begin 
REG : entity work.gen_register(behavior)
  generic map(
  REG_ADR_WIDTH
  )
  port map(
  pi_data => s_data_in,
  pi_clk => s_clk,
  pi_rst => s_rst,
  po_data => s_data_out
  );
  
process
  variable v_error_count : integer := 0;
  variable i : integer := 0;
begin
   while i <= (2**REG_ADR_WIDTH) - 1 loop
   s_clk <= '1'; --rising edge 
   wait for 5 ns;
   s_clk <= '0'; --falling edge 
   wait for 5 ns;
   
   s_data_in <= std_logic_vector(to_unsigned(i,REG_ADR_WIDTH));
   
   i := i + 1;
   
   assert (s_data_in = s_data_out) report "Had an error width input: " & integer'image(i) severity error;
   end loop;
   wait for 10 ns;
   
   s_rst <= '1';
   wait for 10 ns;
   
   for j in 0 to REG_ADR_WIDTH-1 loop
    if s_data_out(j) /= '0' then
     v_error_count := v_error_count + 1;
    end if;
   end loop;
   
   assert v_error_count = 0 report "Had an error with reset" severity error;

   s_rst <= '0';
   wait for 10 ns;
     
   assert false report "end of test" severity note;
   wait;
  end process;
end architecture testbench;


