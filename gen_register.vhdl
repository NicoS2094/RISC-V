-- 1. Participant First and Last Name: Nicolas Schmidt
-- 2. Participant First and Last Name: Jakob Krug


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_Package.all;

entity gen_register is
   generic (
   registerWidth : integer := REG_ADR_WIDTH
   );
   port(
   pi_data : in std_logic_vector(registerWidth - 1 downto 0);
   pi_clk : in std_logic := '0';
   pi_rst : in std_logic := '0';
   po_data : out std_logic_vector(registerWidth - 1 downto 0) := (others => '0')
   
   );
end gen_register;

architecture behavior of gen_register is
 signal s_clk : std_logic := '0';
 signal s_rst : std_logic := '0';
 signal s_cur_d : std_logic_vector(registerWidth - 1 downto 0) := (others => '0');
 
 begin 
    s_clk <= pi_clk;
    s_rst <= s_rst;

 process(s_clk, s_rst, s_cur_d)
 begin
  if falling_edge(s_clk) then
  s_cur_d <= pi_data;
  end if;
  
  if (s_rst = '1') then 
  s_cur_d <= (others => '0'); 
  end if;
  
  po_data <= s_cur_d;
 end process;
end behavior;
