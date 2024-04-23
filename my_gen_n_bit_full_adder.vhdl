library ieee;
use ieee.std_logic_1164.all;

entity my_gen_n_bit_full_adder is
  Generic (
    dataWidth : integer := 8
  );
  port (
	pi_a, pi_b : in std_logic_vector(dataWidth-1 downto 0);
	pi_carryIn : in std_logic;
	po_sum: out std_logic_vector(dataWidth-1 downto 0);
	po_carryOut: out std_logic
  );
end my_gen_n_bit_full_adder;

architecture structure of my_gen_n_bit_full_adder is
	signal s_carry, s_b: std_logic_vector(dataWidth-1 downto 0);
begin
	GEN_FA: for i in dataWidth-1 downto 0 generate
		s_b(i) <= pi_b(i) xor pi_carryIn;
		GEN_FA_0: if i = 0 generate 
			fa_0: entity work.my_full_adder(structure)
			port map (pi_a(i), s_b(i), pi_carryIn, po_sum(i), s_carry(i));
		end generate;
		GEN_FA_INST: if i /= 0 generate
			fa_inst: entity work.my_full_adder(structure)
			port map (pi_a(i), s_b(i), s_carry(i-1), po_sum(i), s_carry(i));
		end generate;
	end generate;
	po_carryOut <= s_carry(dataWidth-1);
end structure;
