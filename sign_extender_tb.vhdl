-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:
 
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;
use work.util_functions_package.all;

entity sign_extender_tb is
end entity sign_extender_tb;

architecture behavior of sign_extender_tb is

  constant PERIOD : time := 10 ns; -- Example: ClockPERIOD of 10 ns
  signal s_clk : std_logic := '0';
  signal s_iInstruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_uInstruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_bInstruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_Instruction : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_iImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_iImmout : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_uImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_uImmout : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_bImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_bImmout : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_jImmout : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
  signal s_jImmexpect : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

begin


  dut1 : entity work.sign_extender(sign_extender)

    port map(
      pi_instr => s_Instruction,
      po_jlmmediate => s_jImmout,
      po_blmmediate => s_bImmout,
      po_ulmmediate => s_uImmout,
      po_ilmmediate  => s_iImmout
    );

  proc : process is

    variable v_uExtended : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    variable v_tmp : std_logic_vector(11 downto 0) := (others => '0');
    variable s_uImmediate : std_logic_vector(19 downto 0) := (others => '0');

  begin

    for i in - ((2 ** 12) - 1) / 2 to ((2 ** 12) - 1) / 2 loop

      s_Instruction <= f_buildInstructionIAlu(ADD_OP_ALU, 0, i, 0);
      s_iImmexpect <= std_logic_vector(to_signed((i), WORD_WIDTH));

      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      assert (s_iImmexpect = s_iImmout)
      report "Had error in sign extender with i-format: Output is  " & to_string(s_iImmout) & " but should be " & to_string(s_iImmexpect) & " Input is " & to_string(s_iInstruction)
        severity error;

    end loop;

    for i in - ((2 ** 20) - 1) / 2 to ((2 ** 20) - 1) / 2 loop

      s_Instruction <= f_buildInstructionU(LUI_OP_INS, i, 0);
      v_uExtended := std_logic_vector(to_signed((i), WORD_WIDTH));
      s_uImmediate := (std_logic_vector(signed(v_uExtended(19 downto 0))));
      s_uImmexpect <= std_logic_vector(signed(v_uExtended(19 downto 0))) & v_tmp;
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      assert (s_uImmexpect = s_uImmout)
      report "Had error in sign extender with u-format" severity error;

    end loop;

    for i in - ((2 ** 12) - 1) / 2 to ((2 ** 12) - 1) / 2 loop

      s_Instruction <= f_buildInstructionB(FUNC3_BGEU, 0, 0, i);
      s_bImmexpect <= std_logic_vector(to_signed((i * 2), WORD_WIDTH));

      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

      assert (s_bImmexpect = s_bImmout)
      report "Had error in sign extender with b-format" severity error;

    end loop;

      for i in - ((2 ** 20) - 1) / 2 to ((2 ** 20) - 1) / 2 loop

        s_Instruction <= f_buildInstructionJ(i, 0);
        s_jImmexpect <= std_logic_vector(to_signed((i * 2), WORD_WIDTH));
  
        s_clk <= '1';
        wait for PERIOD / 2;
        s_clk <= '0';
        wait for PERIOD / 2;
  
        assert (s_jImmexpect = s_jImmout)
        report "Had error in sign extender with j-format"
            severity error;
  
      end loop;
    

    assert false
    report "end of test"
      severity note;

    wait; --  Wait forever; this will finish the simulation.

  end process;

end architecture behavior;
