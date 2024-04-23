library ieee;
use ieee.std_logic_1164.all;

entity my_half_adder is
  port (
	pi_a, pi_b: in std_logic;
	po_sum, po_carryOut: out std_logic
  );
end my_half_adder;

architecture dataflow of my_half_adder is
signal s_temp : std_logic;
  begin
	po_sum <= ((pi_a NAND pi_a) NAND pi_b) NAND (pi_a NAND (pi_b NAND pi_b));
	po_carryOut <= (pi_a NAND pi_b) NAND (pi_a NAND pi_b);
end dataflow;