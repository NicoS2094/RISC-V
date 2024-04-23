library ieee;
use ieee.std_logic_1164.all;

entity my_full_adder is
  port (
	pi_a, pi_b, pi_carryIn: in std_logic;
	po_sum, po_carryOut: out std_logic
  );
end my_full_adder;

architecture structure of my_full_adder is
	signal s_sum1, s_carry1, s_carry2: std_logic;
begin
	HA_1: entity work.my_half_adder(dataflow) port map (pi_a, pi_b, s_sum1, s_carry1);
	HA_2: entity work.my_half_adder(dataflow) port map (s_sum1, pi_carryIn, po_sum, s_carry2);
	po_carryOut <= (s_carry1 NAND s_carry1) NAND (s_carry2 NAND s_carry2);
end structure;
