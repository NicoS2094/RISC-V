library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;
use work.CONSTANT_Package.ALL;

entity my_shifter is
    generic(
        dataWidth : integer := DATA_WIDTH_GEN
    );
    port(
	pi_op1, pi_op2: in std_logic_vector(dataWidth-1 downto 0);
	pi_shiftType, pi_shiftDir: in std_logic;
	po_res: out std_logic_vector(dataWidth-1 downto 0)
    );
end entity;

architecture behavior of my_shifter is
 signal s_shamtInt : integer range 0 to (2**(integer(log2(real(dataWidth)))));
 signal s_tmp_val :  std_logic:='0';
begin
    s_shamtInt <= to_integer( unsigned(pi_op2(integer(log2(real(dataWidth))) - 1 downto 0)));
	process (pi_op1, s_shamtInt, pi_shiftType, pi_shiftDir) begin
		-- Set all bits to desired default
		if pi_shiftType = '0' then
			-- Logical shift: all 0
			po_res <= (others => '0');
		else
			-- Arithmetical shift: all to highest input bit
			po_res <= (others => pi_op1(dataWidth-1));
		end if;
		if pi_shiftDir = '0' then
			po_res(dataWidth-1 downto s_shamtInt) <= pi_op1(dataWidth-1-s_shamtInt downto 0);
		else
			po_res(dataWidth-1-s_shamtInt downto 0) <= pi_op1(dataWidth-1 downto s_shamtInt);
		end if;
	end process;
end architecture behavior;
