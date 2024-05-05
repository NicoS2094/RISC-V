-- Laboratory RA solutions/versuch3
-- Sommersemester 24
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Nicolas Schmidt
-- 2. Participant First and Last Name: Jakob Krug
 
 
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 25.04.2024
-- Description:  R-Only-RISC-V foran incomplete RV32I implementation, support
--               only R-Instructions. 
--
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;
  use work.types_package.all;
  use work.util_functions_package.all;

entity R_only_RISC_V_tb is
end entity R_only_RISC_V_tb;

architecture structure of R_only_RISC_V_tb is

  constant PERIOD                : time                                           := 10 ns;
  constant ADD_FOUR_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)      := std_logic_vector(to_signed((4), WORD_WIDTH));
  signal   s_carryIn_fa, s_clk_pc, s_rst_pc, s_rst_ic, s_clk_iii, s_rst_iii, s_clk_d, s_clk_iei, s_rst_iei, s_clk_ier, s_rst_ier, s_clk_emi, s_rst_emi, s_clk_emr, s_rst_emr, s_clk_mwi, s_rst_mwi, s_clk_mwr, s_rst_mwr, s_clk_rf, s_rst_rf, s_writeEnable_rf, s_clk_ieo1, s_rst_ieo1, s_clk_ieo2, s_rst_ieo2, s_CLK_alu, s_CARRY_OUT_alu, s_clk_ema, s_rst_ema, s_cla_mwa, s_rst_mwa : std_logic := '0';
  signal   s_op1_fa, s_op2_fa, s_sum_fa, s_sum_fa, s_data_pc, s_dataOut_pc, s_adr_ic, s_instruction_ic, s_data_iii, s_dataOut_iii, s_instruction_d, s_writeRegData_rf, s_readRegData1_rf, s_readRegData2_rf, s_data_ieo1, s_data_ieo2, s_dataOut_ieo1, s_dataOut_ieo2, s_OP1_alu, s_OP2_alu, s_ALU_OUT_alu, s_data_ema, s_dataOut_ema, s_data_mwa, s_dataOut_mwa  : std_logic_vector(WORD_WIDTH - 1 downto 0);
  signal   s_data_ier, s_dataOut_ier, s_data_emr, s_dataOut_emr, s_data_mwr, s_datOut_mwr, s_readRegAddr1_rf, s_readRegAddr2_rf, s_writeRegAddr_rf : std_logic_vector(REG_ADR_WIDTH - 1 downto 0);
  signal   s_instructionCache_ic : in memory :=(others => (others => '0'));
  signal   s controlWord_d, s_data_iei, s_dataOut_iei, s_data_emi, s_dataOut_emi, s_data_mwi, s_dataOut_mwi : controlWord := control_word_init;
  signal   s_ALU_OP_alu : std_logic_vector(ALU_OP_WIDTH - 1downto 0);
  signal   s_registersOut : registerMemory := (others => (others => '0'));                                                                                                       
  signal   s_instructions : memory:= (
     4=> "0" & OR_ALU_OP (ALU_OPCODE_WIDTH -git@gitlab.uni-ulm.de:oop-ss24/students/nicolas-schmidt-1707/sheet-1.git 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & OR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(10, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
     8=> "0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    12=> "0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(11, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    16=> "0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    24=> "0" & ADD_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(8, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & ADD_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    28=> "0" & SUB_OP_ALU (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & SUB_OP_ALU(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    32=> "0" & AND_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & AND_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
    36=> "0" & XOR_ALU_OP (ALU_OPCODE_WIDTH - 1) & "00000" & std_logic_vector(to_unsigned(2, REG_ADR_WIDTH)) & std_logic_vector(to_unsigned(1, REG_ADR_WIDTH)) & XOR_ALU_OP(ALU_OPCODE_WIDTH - 2 downto 0) & std_logic_vector(to_unsigned(12, REG_ADR_WIDTH)) & ADD_OP_INS, -- R-Befehle haben alle den gleichen Opcode, daher hier hardkodiert
                                         others => (others => '0')
                                  );

begin

   full_adder: entity work.my_gen_n_bit_full_adder.vhdl
   port map(
   s_op1_fa <= pi_a, 
   s_op2_fa <= pi_b, 
   s_carryIn_fa <= pi_carryIn, 
   s_sum_fa <= po_sum, 
   s_carryOut_fa <= po_carryOut 
   );
   s_op2_fa <= s_sum_fa;
   s_data_pc <= s_sum_fa;
   
   pc: entity work.gen_register.vhdl 
   port map(
   s_data_pc <= pi_data, 
   s_clk_pc <= pi_clk, 
   s_rst_pc <= pi_rst, 
   s_dataOut_pc <= po_data
   );
   s_instructionCache_ic <= s_dataOut_pc;
   
   instruction_cache: entity work.instruction_cache.vhdl 
   port map(
   s_clk_ic <= pi_clk, 
   s_adr_ic <= pi_adr, 
   s_instructionCache_ic <= pi_instructionCache, 
   s_instruction_ic <= po_instruction
   );
   s_data_iii <= s_instruction_ic;
   
   if_id_instr: entity work.gen_register.vhdl
   port map(
   s_data_iii <= pi_data, 
   s_rst_iii <= pi_srt, 
   s_clk_iii <= pi_clk,
   s_dataOut_iii <= po_data
   ); 
   s_instruction_d <= s_dataOut_iii;
   s_data_ier <= s_dataOut_iii;
   s_readAddr1_rf <= s_dataOut_iii;
   s_readAddr2_rf <= s_dataout_iii;
   
   id_ex_rs: entity work.gen_register.vhdl
   port map(
   s_data_ier <= pi_data, 
   s_rst_ier <= pi_srt, 
   s_clk_ier <= pi_clk,
   s_dataOut_ier <= po_data
   );
   s_data_emr <= s_dataOut_ier;
   
   ex_mem_rs: entity work.gen_register.vhdl 
   port map(
   s_data_emr <= pi_data, 
   s_rst_emr <= pi_srt, 
   s_clk_emr <= pi_clk,
   s_dataOut_emr <= po_data
   );
   s_rst_mwr <= s_dataOut_emr;
   
   mem_wd_rs: entity work.gen_register.vhdl
   port map(
   s_data_mwr <= pi_data, 
   s_rst_mwr <= pi_srt, 
   s_clk_mwr <= pi_clk,
   s_dataOut_mwr <= po_data
   );
   pi_writeRegAddr_rf <= s_dataOut_mwr;
   
   decoder: entity work.decoder.vhdl 
   port map(
   s_clk_d <= pi_clk,
   s_instruction_d <= pi_instruction,
   s_controlWord_d <= po_controlWord
   );
   s_data_iei <= s_controlWord_d;
   
   id_ex_instr: entity work.ControlWordRegister.vhdl 
   port map(
   s_clk_iei <= pi_clk,
   s_rst_iei <= pi_rst,
   s_data_iei <= pi_data,
   s_dataOut_iei <= po_dataOut
   );
   s_data_emi <= s_dataOut_iei;
   s_ALU_OP_alu <= s_dataOut_iei;
   
   ex_mem_instr: entity work.ControlWordRegister.vhdl 
   port map(
   s_clk_emi <= pi_clk,
   s_rst_emi <= pi_rst,
   s_data_emi <= pi_data,
   s_dataOut_emi <= po_dataOut
   );
   s_data_mwi <= s_dataOut_emi;
   
   mem_wd_instr: entity work.ControlWordRegister.vhdl 
   port map(
   s_clk_mwi <= pi_clk,
   s_rst_mwi <= pi_rst,
   s_data_mwi <= pi_data,
   s_dataOut_mwi <= po_dataOut
   );
   s_writeEnable_rf <= not(s_dataOut_mwi);
   
   register_file: entity work.register_file.vhdl
   port map(
   s_clk_rf <= pi_clk,
   s_rst_rf <= pi_rst,
   s_writeEnable_rf <= pi_writeEnable,
   s_readRegAddr1_rf <= pi_readRegAddr1,
   s_readRegAddr2_rf <= pi_readRegAddr2,
   s_writeRegAddr_rf <= pi_writeRegAddr,
   s_writeRegData_rf <= pi_writeRegData,
   s_readRegData1_rf <= po_readRegData1,
   s_readRegData2_rf <= po_readRegData2,
   s_registerOut_rf <= po_registerOut 
   );
   s_data1_ieo1 <= s_readRegData1_rf;
   s_data2_ieo2 <= s_readRegData2_rf;
   
   id_ex_op1: entity work.gen_register.vhdl
   port map(
   s_clk_ieo1 <= pi_clk,
   s_rst_ieo1 <= pi_rst,
   s_data_ieo1 <= pi_data,
   s_dataOut_ieo1 <= po_data
   );
   s_OP1_alu <= s_dataOut_ieo1;
   
   id_ex_op2: entity work.gen_register.vhdl
   port map(
   s_clk_ieo2 <= pi_clk,
   s_rst_ieo2 <= pi_rst,
   s_data_ieo <= pi_data,
   s_dataOut_ieo2 <= po_data
   );
   s_OP2_alu <= s_dataOut_ieo2;
   
   my_alu: entity work.my_alu.vhdl
   port map(
   s_CLK_alu <= pi_CLK,
   s_ALU_OP_alu <= pi_ALU_OP,
   s_OP1_alu <= pi_OP1,
   s_OP2_alu <= pi_OP2,
   s_ALU_OUT_alu <= po_ALU_OUT,
   s_CARRY_OUT_alu <= po_CARRY_OUT
   );
   s_data_ema <= s_ALU_OUT_alu;
   
   ex_mem_alures: entity work.gen_register.vhdl
   port map(
   s_clk_ema <= pi_clk,
   s_rst_ema <= pi_rst,
   s_data_ema <= pi_data,
   s_dataOut_ema <= po_data
   );
   s_data_mwa <= s_dataOut_ema;
   
   ex_wb_alures: entity work.gen_register.vhdl
   port map(
   s_clk_mwa <= pi_clk,
   s_rst_mwa <= pi_rst,
   s_data_mwa <= pi_data,
   s_dataOut_mwa <= po_data
   );
   s_writeRegData_rf <= s_dataOut_mwa;
   
  process is
  begin
      s_clk <= '0';
      wait for PERIOD / 2;

   for i in 0 to 14 loop
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

    if (i = 5) then -- after 5 clock clock cycles
        assert (to_integer(signed(s_registersOut(10))) = 9)
          report "OR-Operation failed. Register 10 contains " & integer'image(to_integer(signed(s_registersOut(10)))) & " but should contain " & integer'image(9) & " after cycle 4"
          severity error;
     end if;

    if (i = 6) then -- after 6 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(8)))= 17)
          report "ADD-Operation failed. Register 8 contains " & integer'image(to_integer(signed(s_registersOut(8)))) & " but should contain " & integer'image(17) & " after cycle 5"
          severity error;
     end if;

      if (i =7) then -- after 6 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(11))) = 1)
          report "SUB-Operation failed. Register 11 contains " & integer'image(to_integer(signed(s_registersOut(11)))) & " but should contain " & integer'image(1) & " after cycle 6"
          severity error;
     end if;

      if (i = 9) then -- after 8 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(12))) = 1)
          report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(1) & " after cycle 8"
          severity error;

     end if;
      if (i = 10) then -- after 7 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(12))) = 25)
          report "ADD-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(25) & " after cycle 7"
          severity error;
     end if;

           if (i = 11) then -- after 9 clock clock cycles, the pi_first result should be written to the RF
        assert (to_integer(signed(s_registersOut(12))) = -1)
          report "SUB-Operation failed. Register 12 contains " & integer'image(to_integer(signed(s_registersOut(12)))) & " but should contain " & integer'image(-1) & " after cycle 8"
          severity error;
     end if;
    end loop;
    report "End of test!!!";
wait;

  end process;

  process is
  begin

    wait for PERIOD / 4;

    for i in 0 to 200 loop

      s_clk2 <= '0';
      wait for PERIOD / 2;
      s_clk2 <= '1';
      wait for PERIOD / 2;

    end loop;

    wait;

  end process;

end architecture;
