library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;
  use work.types_package.all;

entity riub_only_RISC_V is
  port (
    pi_clk         : in    std_logic;
    pi_instruction : in    memory := (others => (others => '0'));
    po_registersOut : out   registerMemory := (others => (others => '0'))
  );
end entity riub_only_RISC_V;

architecture structure of riub_only_RISC_V is

  constant PERIOD                : time                                            := 10 ns;
  constant ADD_FOUR_TO_ADDRESS   : std_logic_vector(WORD_WIDTH - 1 downto 0)       := std_logic_vector(to_signed((4), WORD_WIDTH));
  -- signals
  signal   s_op1EX                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_op2EX                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_op1ID                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_op2ID                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_aluOutEX             : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_aluOutMEM            : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_aluOutWB             : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_wbMuxOut             : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0'); 
  signal   s_instructionAddress   : std_logic_vector(WORD_WIDTH - 1 downto 0)      := x"FFFFFFFC";
  signal   s_instrIF              : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_instrID              : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_imedeateEX           : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_immMuxOut            : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_uimmmuxout           : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  
  signal   s_pcMuxOut             : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pc_MuxOut            : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_uImmediateID         : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_jImmediateID         : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_iImmediateID         : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_bImmediateID         : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_immediateEX          : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_immediateMEM         : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_immediateWB          : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_immediateID          : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  
  signal   s_pcIn                 : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pcID                 : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pcEX                 : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pcMEM                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pcIF                 : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pc4In                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pc4ID                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pc4EX                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pc4MEM               : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pc4WB                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_pc4IF                : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_rst                  : std_logic                                      := '0';
  signal   s_rst_reg              : std_logic                                      := '0';
  signal   s_clk                  : std_logic                                      := '0';
  signal   s_carryOut             : std_logic                                      := '0';
  signal   s_dAdressEX            : std_logic_vector(REG_ADR_WIDTH - 1 downto 0)   := (others => '0');
  signal   s_dAdressWB            : std_logic_vector(REG_ADR_WIDTH - 1 downto 0)   := (others => '0');
  signal   s_dAdressMEM           : std_logic_vector(REG_ADR_WIDTH - 1 downto 0)   := (others => '0');
  signal   s_controlWordID        : controlWord                                    := CONTROL_WORD_INIT;
  signal   s_controlWordEX        : controlWord                                    := CONTROL_WORD_INIT;
  signal   s_controlWordMEM       : controlWord                                    := CONTROL_WORD_INIT;
  signal   s_controlWordWB        : controlWord                                    := CONTROL_WORD_INIT;
  signal   s_registersOut         : registerMemory := (others => (others => '0'));
  signal   s_instructions         : memory := (others => (others => '0'));

  signal   s_branchDestEX         : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_branchDestMEM        : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_branch_MuxOut        : std_logic_vector(WORD_WIDTH - 1 downto 0)      := (others => '0');
  signal   s_zero                 : std_logic                                      := '0';
  signal   s_b_selEX                 : std_logic                                      := '0';
  signal   s_b_selMEM                 : std_logic                                      := '0';

begin

  s_clk<=pi_clk;
  s_instructions<=pi_instruction;
  po_registersOut<=s_registersOut;



--program counter adder and pc-register

  pc_incrementer : entity work.my_gen_n_bit_full_adder
    generic map (WORD_WIDTH)
    port map (
      pi_op1         => s_instructionAddress,
      pi_op2         => ADD_FOUR_TO_ADDRESS,
      pi_carryIn   => '0',
      po_sumOut       => s_pcIn
    );
     
  pc_mux : entity work.gen_mux
    generic map (WORD_WIDTH)
    port map (
      pi_first    => s_pcIn,
      pi_second   => s_aluOutMEM,
      pi_selector => s_controlWordMEM.PC_SEL,
      po_output   => s_pc_MuxOut
    );

  branch_mux : entity work.gen_mux
    generic map (WORD_WIDTH)
    port map (
      pi_first    => s_pc_MuxOut,
      pi_second   => s_branchDestMEM,
      pi_selector => s_b_selMEM,
      po_output   => s_branch_MuxOut
    );

  pc : entity work.gen_register
  generic map (WORD_WIDTH)
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_branch_MuxOut,
      po_data => s_instructionAddress
    );
  pc4 : entity work.gen_register
  generic map (WORD_WIDTH)
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_pcIn,
      po_data => s_pc4IF
    );




--instruction fetch 

  instrcache : entity work.instruction_cache
    port map (
      pi_clk              => s_clk,
      pi_adr              => s_instructionAddress,
      pi_instructionCache => s_instructions,
      po_instruction      => s_instrIF
    );



--Pipeline-Register (IF -> ID) start

  if_id_instructionreg : entity work.gen_register
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_instrIF,
      po_data => s_instrID
    );
  IF_ID_PC : entity work.gen_register
    generic map (WORD_WIDTH )
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_instructionAddress,
      po_data => s_pcID
    );
  IF_ID_PC4 : entity work.gen_register
    generic map (WORD_WIDTH )
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_pc4IF,
      po_data => s_pc4ID
    );




--decode phase

  decoder : entity work.decoder
    port map (
      pi_clk           => s_clk,
      pi_instruction   => s_instrID,
      po_controlWord   => s_controlWordID
    );
    
  sign_extender : entity work.sign_extender
    port map (
      pi_instr => s_instrID,
      po_iImmediate  => s_iImmediateID,
      po_uImmediate  => s_uImmediateID,
      po_jImmediate  => s_jImmediateID,
      po_bImmediate  => s_bImmediateID
    );
    
  with s_instrID(6 downto 0) select
    s_immediateID <= s_iImmediateID when I_OP_INS,
                 s_uImmediateID when LUI_OP_INS,
                 s_uImmediateID when AUIPC_OP_INS,
                 s_iImmediateID when JALR_OP_INS,
                 s_jImmediateID when JAL_OP_INS,
                 s_bImmediateID when B_OP_INS,
                 "00000000000000000000000000000000" when others;
   


--Pipeline-Register (ID -> EX) start

  id_ex_immediatereg : entity work.gen_register
    generic map (WORD_WIDTH)
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_immediateID,
      po_data => s_immediateEX
    );

  id_ex_op1 : entity work.gen_register
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_op1ID,
      po_data => s_op1EX
    );
    
  id_ex_op2 : entity work.gen_register
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_op2ID,
      po_data => s_op2EX
    );
    
  id_ex_controlwordreg : entity work.ControlWordRegister 
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk         => s_clk,
      pi_controlword => s_controlWordID,
      po_controlword => s_controlWordEX
    );

  id_ex_adressrsdreg : entity work.gen_register
    generic map (REG_ADR_WIDTH)
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_instrID(11 downto 7),
      po_data => s_dAdressEX
    );
      
  ID_EX_PC : entity work.gen_register
    generic map (WORD_WIDTH )
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_pcID,
      po_data => s_pcEX
    );
  ID_EX_PC4 : entity work.gen_register
    generic map (WORD_WIDTH )
    port map (
      pi_rst  => s_b_selMEM or s_rst,
      pi_clk  => s_clk,
      pi_data => s_pc4ID,
      po_data => s_pc4EX
    );




--execute phase

  imm_mux : entity work.gen_mux
    port map (
      pi_first    => s_op2EX,
      pi_second   => s_immediateEX,
      pi_selector => s_controlWordEX.I_IMM_SEL,
      po_output   => s_immMuxOut
    );

  --- mux for input 1 ALU
  alu1_mux : entity work.gen_mux
    generic map (WORD_WIDTH)
    port map (
      pi_first    => s_op1EX,
      pi_second   => s_pcEX,
      pi_selector => s_controlWordEX.A_SEL,
      po_output   => s_pcMuxOut
    );

  alu : entity work.my_alu
    generic map (WORD_WIDTH, ALU_OPCODE_WIDTH )
    port map (
      pi_op1      => s_pcMuxOut,
      pi_op2      => s_immMuxOut,
      pi_aluOp    => s_controlWordEX.ALU_OP,
      po_aluOut   => s_aluOutEX,
      po_carryOut => s_carryOut,
      po_zero     => s_zero
    );

  branch_alu : entity work.my_gen_n_bit_full_adder
    generic map (WORD_WIDTH)
    port map (
      pi_op1         => s_pcEX,
      pi_op2         => s_immediateEX,
      pi_carryIn   => '0',
      po_sumOut       => s_branchDestEX
    );

    -- estimate branch deciscion

    s_B_SELEX<= '1' when s_controlWordEX.IS_BRANCH and (s_zero xor s_controlWordEX.CMP_RESULT) else '0';


---********************************************************************
---* Pipeline-Register (EX -> MEM) start

  ex_mem_immediatereg : entity work.gen_register
    generic map (WORD_WIDTH)
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_immediateEX,
      po_data => s_immediateMEM
    );

  ex_mem_controlwordreg : entity work.ControlWordRegister
    port map (
      pi_rst         => s_rst,
      pi_clk         => s_clk,
      pi_controlword => s_controlWordEX,
      po_controlword => s_controlWordMEM
    );
    
  ex_mem_adressrsdreg : entity work.gen_register
    generic map (REG_ADR_WIDTH)
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_dAdressEX,
      po_data => s_dAdressMEM
    );
    
  ex_mem_aluresultreg : entity work.gen_register
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_aluOutEX,
      po_data => s_aluOutMEM
    );

  EX_MEM_PC4 : entity work.gen_register
    generic map (WORD_WIDTH)
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_pc4EX,
      po_data => s_pc4MEM
    );
  EX_MEM_Branch : entity work.gen_register
    generic map (WORD_WIDTH)
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_branchDestEX,
      po_data => s_branchDestMEM
    );

---********************************************************************

    process (s_clk,s_rst)

    begin
        if (s_rst) then
            s_b_selMEM <='0';
        elsif rising_edge (s_clk) then
            s_b_selMEM <= s_b_selEX; -- update register contents on falling clock edge
        end if;
    end process;




---* memory phase





--Pipeline-Register (MEM -> WB) start

  mem_wb_uimmediatereg : entity work.gen_register
    generic map (WORD_WIDTH)
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_immediateMEM,
      po_data => s_immediateWB
    );

  mem_wb_controlwordreg : entity work.ControlWordRegister
    port map (
      pi_rst         => s_rst,
      pi_clk         => s_clk,
      pi_controlword => s_controlWordMEM,
      po_controlword => s_controlWordWB
    );
    
  mem_wb_adressrsdreg : entity work.gen_register
    generic map (REG_ADR_WIDTH )
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_dAdressMEM,
      po_data => s_dAdressWB
    );
    
  mem_wb_aluresultreg : entity work.gen_register
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_aluOutMEM,
      po_data => s_aluOutWB
    );

  MEM_WB_PC4 : entity work.gen_register
    generic map (WORD_WIDTH )
    port map (
      pi_rst  => s_rst,
      pi_clk  => s_clk,
      pi_data => s_pc4MEM,
      po_data => s_pc4WB
    );



---********************************************************************
--write back phase

  lui_mux : entity work.gen_mux4
    generic map (WORD_WIDTH)
    port map (
      pi_first    => s_aluOutWB,
      pi_second   => s_immediateWB,
      pi_third    => s_pc4wb,
      pi_four     => s_pc4wb,
      pi_selector => s_controlWordWB.WB_SEL,
      po_output   => s_wbMuxOut
    );

--register File

  register_file : entity work.register_file
    port map (
      pi_readRegAddr1          => s_instrID(19 downto 15),
      pi_readRegAddr2          => s_instrID(24 downto 20),
      pi_writeRegAddr          => s_dAdressWB,
      pi_writeRegData          => s_wbMuxOut,
      pi_clk                   => s_clk,
      pi_rst                   => s_rst,
      pi_writeEnable           => not s_controlWordEX.IS_BRANCH,
      po_readRegData1          => s_op1ID,
      po_readRegData2          => s_op2ID,
      po_registerOut           => s_registersOut
    );

---********************************************************************

end architecture;
