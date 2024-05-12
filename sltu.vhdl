library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;

entity sltu is
    generic(
        dataWidth : integer := DATA_WIDTH_GEN
    );
    port(
        pi_op1 : in std_logic_vector(dataWidth - 1 downto 0);
        pi_op2 : in std_logic_vector(dataWidth - 1 downto 0);
        po_out : out std_logic_vector(dataWidth - 1 downto 0)
    );
end sltu;

architecture behavior of sltu is
    begin
    process(pi_op1, pi_op2)
        begin
        if (to_integer(signed(pi_op2)) /= 0) and (pi_op1 < pi_op2) then
            po_out <= std_logic_vector(to_unsigned(1, dataWidth));
        else 
            po_out <= std_logic_vector(to_unsigned(0, dataWidth));
        end if;
    end process;
end architecture;            