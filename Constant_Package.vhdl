-- ========================================================================
-- Author:       Marcel Rieß, with additions by Niklas Gutsmiedl
-- Last updated: 19.03.2024
-- Description:  Holds various constants related to the RV instruction
--               set that are used throughout the implementation
-- ========================================================================

library IEEE;
  use ieee.std_logic_1164.all;

package constant_package is

  -- General constants
  constant ALU_OPCODE_WIDTH : integer := 4;
  constant OPCODE_WIDTH     : integer := 7;
  constant DATA_WIDTH_GEN   : integer := 8;
  constant REG_ADR_WIDTH    : integer := 5;
  constant ADR_WIDTH        : integer := 32;
  constant WORD_WIDTH       : integer := 16;
  constant FUNC3_WIDTH      : integer := 3;

  -- Instruction Opcodes for ALU
  constant AND_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0111";
  constant XOR_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0100";
  constant OR_ALU_OP  : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0110";

  constant SLL_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0001"; 
  constant SRL_ALU_OP : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0101"; 
  constant SRA_OP_ALU : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "1101";

  constant ADD_OP_ALU : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0000";
  constant SUB_OP_ALU : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "1000";

  constant SLT_OP_ALU  : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0010";
  constant SLTU_OP_ALU : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "0011";

  constant EQ_OP_ALU : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := "1110"; -- Added this to simplify branch implementation

  constant FUNC3_SHIFTR : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "101";
  constant FUNC3_BEQ     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "000";
  constant FUNC3_BNE     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "001";
  constant FUNC3_BLT     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "100";
  constant FUNC3_BGE     : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "101";
  constant FUNC3_BLTU    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "110";
  constant FUNC3_BGEU    : std_logic_vector(FUNC3_WIDTH - 1 downto 0) := "111";

  -- RISC-V Instruction Opcodes: Since some instructions (e.g. all R-Format instructions) share the same opcode, only one of them is declared here

  -- U-Format
  constant LUI_OP_INS   : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0110111"; -- lui
  constant AUIPC_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0010111"; -- auipc

  -- J-Format
  constant JAL_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "1101111"; -- jal

  -- B-Format
  constant BEQ_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "1100011"; -- beq, all B-Format instructions have the same opcode

  -- S-Format
  constant SB_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0100011"; -- sb

  -- I-Format
  constant JALR_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "1100111"; -- jalr

  constant LB_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0000011"; -- lb

  constant ADDI_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0010011"; -- addi

  -- R-Format
  constant ADD_OP_INS : std_logic_vector(OPCODE_WIDTH - 1 downto 0) := "0110011"; -- add

end package constant_package;
