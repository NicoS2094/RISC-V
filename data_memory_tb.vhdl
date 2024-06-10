--Author: Nicolas Schmidt
--Author: Jakob Benedigt Krug

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;
  use work.types_package.all;
  
  
  entity data_memory_tb is
  end data_memory_tb;
  
  architecture test of data_memory_tb is
  
      signal s_clk            : std_logic := '0';
      signal s_rst            : std_logic := '0';
      signal s_adr         : std_logic_vector(ADR_WIDTH - 1 downto 0) := (others => '0');
      signal s_ctrmem      : std_logic_vector(2 downto 0) := (others => '0');
      signal s_write       : std_logic := '0';
      signal s_read        : std_logic := '0';
      signal s_writedata   : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
      signal s_readdata    : std_logic_vector(WORD_WIDTH - 1 downto 0);
      signal s_debugdatamemory : memory;
  
      component data_memory is
          generic (
              adr_width : integer := ADR_WIDTH;
              mem_size  : integer := 2 ** 10
          );
          port (
              pi_adr                : in std_logic_vector(adr_width - 1 downto 0);
              pi_clk                : in std_logic;
              pi_rst                : in std_logic;
              pi_ctrmem             : in std_logic_vector(3 - 1 downto 0);
              pi_write              : in std_logic;
              pi_read               : in std_logic;
              pi_writedata          : in std_logic_vector(WORD_WIDTH - 1 downto 0);
              po_readdata           : out std_logic_vector(WORD_WIDTH - 1 downto 0);
              po_debugdatamemory    : out memory
          );
      end component;
  
  begin
      uut: data_memory
          port map (
              pi_adr => s_adr,
              pi_clk => s_clk,
              pi_rst => s_rst,
              pi_ctrmem => s_ctrmem,
              pi_write => s_write,
              pi_read => s_read,
              pi_writedata => s_writedata,
              po_readdata => s_readdata,
              po_debugdatamemory => s_debugdatamemory
          );
      clk_process : process
      begin
          while True loop
              s_clk <= '0';
              wait for 10 ns;
              s_clk <= '1';
              wait for 10 ns;
          end loop;
      end process;
  
      data_memory_process: process
      begin
          -- Reset der Memmory
          s_rst <= '1';
          wait for 20 ns;
          s_rst <= '0';
  
          --Schreiben Operationen

          --Wort speichern
          s_adr <= x"00000004";
          s_writedata <= x"DEADBEEF";
          s_ctrmem <= SW_OP;
          s_write <= '1';
          wait for 20 ns;
          s_write <= '0';
          assert s_debugdatamemory(4) = x"DEADBEEF" report "Error: Expected DEADBEEF, got " & integer'image(to_integer(signed(s_debugdatamemory(4)))) severity error;

          --Byte speichern
          s_adr <= x"00000008";
          s_writedata <= x"000000FF";
          s_ctrmem <= SB_OP;
          s_write <= '1';
          wait for 20 ns;
          s_write <= '0';
          assert s_debugdatamemory(8)(7 downto 0) = x"FF" report "Error: Expected 000000FF, got " & integer'image(to_integer(signed(s_debugdatamemory(8)(7 downto 0)))) severity error;

          --Halbwort speichern
          s_adr <= x"0000000C";
          s_writedata <= x"0000BEEF";
          s_ctrmem <= SH_OP;
          s_write <= '1';
          wait for 20 ns;
          s_write <= '0';
          assert s_debugdatamemory(12)(15 downto 0) = x"BEEF" report "Error: Expected 0000BEEF, got " & integer'image(to_integer(signed(s_debugdatamemory(12)(15 downto 0)))) severity error;

          --Lesen Operationen
          
          --Wort laden
          s_adr <= x"00000004";
          s_ctrmem <= LW_OP;
          s_read <= '1';
          wait for 20 ns;
          s_read <= '0';
          assert s_readdata = x"DEADBEEF" report "Error: Expected DEADBEEF, got " & integer'image(to_integer(signed(s_readdata))) severity error;

          --Byte laden 
          s_adr <= x"00000008";
          s_ctrmem <= LB_OP;
          s_read <= '1';
          wait for 20 ns;
          s_read <= '0';
          assert s_readdata(7 downto 0) = x"FF" report "Error: Expected 000000FF, got " & integer'image(to_integer(signed(s_readdata(7 downto 0)))) severity error;

          --Halbwort laden
          s_adr <= x"0000000C";
          s_ctrmem <= LH_OP;
          s_read <= '1';
          wait for 20 ns;
          s_read <= '0';
          assert s_readdata(15 downto 0) = x"BEEF" report "Error: Expected 0000BEEF, got " & integer'image(to_integer(signed(s_readdata(15 downto 0)))) severity error;

          --Byte laden(vorzeichenlos)
          s_adr <= x"00000008";
          s_ctrmem <= LBU_OP;
          s_read <= '1';
          wait for 20 ns; 
          s_read <= '0';
          assert s_readdata(7 downto 0) = x"FF" report "Error: Expected 000000FF, got " & integer'image(to_integer(unsigned(s_readdata(7 downto 0)))) severity error;

          --Halbwort laden(vorzeichnlos)
          s_adr <= x"0000000C";
          s_ctrmem <= LHU_OP;
          s_read <= '1';
          wait for 20 ns;
          s_read <= '0';
          assert s_readdata(15 downto 0) = x"BEEF" report "Error: Expected 0000BEEF, got " & integer'image(to_integer(unsigned(s_readdata(15 downto 0)))) severity error;

          wait for 20 ns;
          report "End of DataMemory Test!";
  
          wait;
      end process;
  end architecture test;
  