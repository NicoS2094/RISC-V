library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.constant_package.all;

entity register_file_tb is
end entity register_file_tb;

architecture behavior of register_file_tb is
-- begin solution:
  signal   s_addressRs1            : std_logic_vector(REG_ADR_WIDTH - 1 downto 0)  := (others => '0');
  signal   s_addressRs2            : std_logic_vector(REG_ADR_WIDTH - 1 downto 0)  := (others => '0');
  signal   s_addressD              : std_logic_vector(REG_ADR_WIDTH - 1 downto 0)  := (others => '0');
  signal   s_regRS1                : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal   s_regRs2                : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal   s_regD                  : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  constant CLK_PERIOD                  : time                                      := 10 ns; -- Example: ClockPERIOD of 10 ns
  signal   s_clk,s_rst, s_writeEnable : std_logic                                 := '0';

begin

  lu1 : entity work.register_file
    generic map (WORD_WIDTH, REG_ADR_WIDTH, 2 ** REG_ADR_WIDTH    )
    port map (
      pi_readRegAddr1          => s_addressRs1,
      pi_readRegAddr2          => s_addressRs2,
      pi_writeRegAddr          => s_addressD,
      po_readRegData1          => s_regRS1,
      po_readRegData2          => s_regRs2,
      pi_writeRegData          => s_regD,
      pi_clk                   => s_clk,
      pi_writeEnable           => s_writeEnable,
      pi_rst                   => s_rst
    );

    -- generate clock 
    clk_process: process
    begin
        while now < 1000 ns loop  -- Simulation for 1000 ns
            s_clk <= '0';
            wait for CLK_PERIOD / 2;
            s_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

  lu : process is
  begin

        -- reset
        s_rst <= '1';
        wait for CLK_PERIOD;
        s_rst <= '0';
        -- test 1
        -- Daten in Register 2 und 3 schreiben
        s_writeEnable <= '1';
        s_addressD <= "00010";  -- Register 2
        s_regD <= "11111111000000001111111100000000";
        wait for CLK_PERIOD;
        s_addressD <= "00011";  -- Register 3
        s_regD <= "11111111000000000000000001111111";
        wait for CLK_PERIOD;
        s_writeEnable <= '0';
        
        -- Daten aus Register 2 und 3 lesen
        s_addressRs1 <= "00010";  -- Register 2
        s_addressRs2 <= "00011";  -- Register 3
        wait for CLK_PERIOD;
        
        -- Testergebnisse überprüfen
        assert s_regRS1 = "11111111000000001111111100000000" report "Fehler beim Lesen von Register 2" severity error;
        assert s_regRS2 = "11111111000000000000000001111111" report "Fehler beim Lesen von Register 3" severity error;


        -- test 2
        -- Daten in Register 4  schreiben
        s_writeEnable <= '1';
        s_addressD <= "00100";  -- Register 4
        s_regD <= "11111111000000001111111100001000";
        -- Daten aus Register 4 und 3 lesen
        s_addressRs1 <= "00100";  -- Register 4
        s_addressRs2 <= "00011";  -- Register 3
        wait for CLK_PERIOD;
        
        -- Testergebnisse überprüfen
        assert s_regRS1 = "00000000000000000000000000000000" report "Fehler beim Lesen von Register 4" severity error;
        assert s_regRS2 = "11111111000000000000000001111111" report "Fehler beim Lesen von Register 3" severity error;
   
        -- test 3
        -- Daten in Register 4  lesen
        s_writeEnable <= '0';
        s_addressD <= "00100";  -- Register 4
        s_regD <= "11111111000000000000000000000000";
        -- Daten aus Register 4 und 3 lesen
        s_addressRs1 <= "00100";  -- Register 4
        s_addressRs2 <= "00011";  -- Register 3
        wait for CLK_PERIOD;
        
        -- Testergebnisse überprüfen
        assert s_regRS1 = "11111111000000001111111100001000" report "Fehler beim Lesen von Register 4" severity error;
        assert s_regRS2 = "11111111000000000000000001111111" report "Fehler beim Lesen von Register 3" severity error;
   
        -- test 4
        -- Daten in Register 0 schreiben und  lesen
        s_writeEnable <= '1';
        s_addressD <= "00000";  -- Register 4
        s_regD <= "11111111000000000000000000000000";
        wait for CLK_PERIOD;
        -- Daten aus Register 4 und 0 lesen
         s_writeEnable <= '0';
        s_addressRs1 <= "00100";  -- Register 4
        s_addressRs2 <= "00000";  -- Register 0
        wait for CLK_PERIOD;
        
        -- Testergebnisse überprüfen
        assert s_regRS1 = "11111111000000001111111100001000" report "Fehler beim Lesen von Register 4" severity error;
        assert s_regRS2 = "00000000000000000000000000000000" report "Fehler beim Lesen von Register 0" severity error;
   


    assert false
      report "end of test"
      severity note;

    wait; --  Wait forever; this will finish the simulation.

  end process lu;
-- end solution!!
end architecture behavior;
