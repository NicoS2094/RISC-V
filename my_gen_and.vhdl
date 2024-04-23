library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Constant_Package.ALL;

entity my_gen_and is
	generic(
		dataWidth : integer := 8
	);
	port (
		op1, op2: in std_logic_vector(dataWidth-1 downto 0);
		res: out std_logic_vector(dataWidth-1 downto 0)
	);
end entity;

architecture dataflow of my_gen_and is
begin
	res <= op1 and op2;
end architecture;