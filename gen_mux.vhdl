-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt


library ieee;
  use ieee.std_logic_1164.all;
  use work.constant_package.all;

entity gen_mux is
  generic(
  dataWidth : integer := DATA_WIDTH_GEN
  );
  port(
  pi_first : in std_logic_vector(dataWidth-1 downto 0) := (others => '0');
  pi_second : in std_logic_vector(dataWidth-1 downto 0) := (others => '0');
  pi_selector : in std_logic := '0';
  po_output : out std_logic_vector(dataWidth-1 downto 0) := (others => '0')
  );
end entity gen_mux;

architecture dataflow of gen_mux is
begin 
po_output <= pi_first when pi_selector = '0' else      
             pi_second when pi_selector = '1';
end architecture dataflow;
