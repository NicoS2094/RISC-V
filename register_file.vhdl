-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Nicolas Schmidt 
-- 2. Participant First and Last Name: Jakob Krug

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;

entity register_file is
    generic(
    word_width : integer := WORD_WIDTH;
    adr_width : integer := REG_ADR_WIDTH;
    reg_amount : integer := 2**REG_ADR_WIDTH
    );
    port(
    pi_clk : in std_logic := '0';
    pi_rst : in std_logic := '0';
    pi_readRegAddr1 : in std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    pi_readRegAddr2 : in std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    pi_writeRegAddr : in std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    pi_writeRegData : in std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    pi_writeEnable : in std_logic := '0';
    po_readRegData1 : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0'); 
    po_readRegData2 : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0') 
    );
end entity register_file;

architecture arc of register_file is
    type reg_array is array (0 to reg_amount - 1) of std_logic_vector (word_width - 1 downto 0);
    signal regs : reg_array := (others => (others => '0'));
    constant REG_0 : std_logic_vector(word_width - 1 downto 0) := (others => '0');
    

begin
    process(pi_clk, pi_rst)
        begin
            if rising_edge(pi_clk) then
                    po_readRegData1 <= regs(to_integer(unsigned(pi_readRegAddr1))); 
                    po_readRegData2 <= regs(to_integer(unsigned(pi_readRegAddr2)));
                if pi_writeEnable = '1' then 
                    regs(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
                end if;
              regs(0) <= REG_0;
            end if;
                if (pi_rst = '1') then
                  for i in 1 to reg_amount - 1 loop
                    regs(i) <= regs(0);
                end loop; 
            end if;
        end process;
end architecture arc;
