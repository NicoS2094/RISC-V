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
  use work.types_package.all;

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
    po_readRegData2 : out std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_registerOut : out registermemory := (others => (others => '0'))
    );
end entity register_file;

architecture arc of register_file is
    signal s_regs : registermemory := (others => (others => '0'));
    signal s_init : boolean := false;
    constant REG_0 : std_logic_vector(word_width - 1 downto 0) := (others => '0');
    

begin
    process(pi_clk, pi_rst, pi_writeEnable)
        begin
            if not s_init then 
            s_regs(1) <= std_logic_vector(to_unsigned(9, WORD_WIDTH));
            s_regs(2) <= std_logic_vector(to_unsigned(8, WORD_WIDTH));
            s_init <= true;
            end if;
            if rising_edge(pi_clk) then
                    po_readRegData1 <= s_regs(to_integer(unsigned(pi_readRegAddr1))); 
                    po_readRegData2 <= s_regs(to_integer(unsigned(pi_readRegAddr2)));
                if pi_writeEnable = '1' then 
                    s_regs(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
                end if;
              s_regs(0) <= REG_0;
            end if;
                if (pi_rst = '1') then
                  for i in 1 to reg_amount - 1 loop
                    s_regs(i) <= s_regs(0);
                end loop; 
            end if;
            po_registerOut <= s_regs;
        end process;
end architecture arc;
