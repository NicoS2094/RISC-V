-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.constant_package.all;

entity my_alu is
-- begin solution:
generic (
  dataWidth  : integer := DATA_WIDTH_GEN;
  opCodeWidth    : integer := OPCODE_WIDTH
);
port(
  pi_op1, pi_op2: in std_logic_vector(dataWidth-1 downto 0);
	pi_aluOp: in std_logic_vector (opCodeWidth-1 downto 0);
	pi_clk: in std_logic;
	po_aluOut: out std_logic_vector (dataWidth-1 downto 0);
	po_carryOut: out std_logic
);
  -- end solution!!
end entity my_alu;

architecture behavior of my_alu is

  signal s_op1               : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_op2               : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res1              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res2              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res3              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res4              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res5              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res6              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res7              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_res8              : std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
  signal s_cin               : std_logic                                   := '0';
  signal s_cout              : std_logic                                   := '0';
  signal s_shiftType         : std_logic                                   := '0';
  signal s_shiftDirection    : std_logic                                   := '0';
  signal s_clk               : std_logic                                   := '0';
  signal s_zeropadding       : std_logic_vector(dataWidth - 1 downto 1) := (others => '0');
  signal s_luOp              : std_logic_vector(opCodeWidth   - 1 downto 0) := (others => '0');

begin

  xor1 : entity work.my_gen_xor
    generic map (
      dataWidth
    )
    port map (
      s_op1,
      s_op2,
      s_res1
    );

  or1 : entity work.my_gen_or
    generic map (
      dataWidth
    )
    port map (
      s_op1,
      s_op2,
      s_res2
    );

  and1 : entity work.my_gen_and
    generic map (
      dataWidth
    )
    port map (
      s_op1,
      s_op2,
      s_res3
    );

  shift : entity work.my_shifter
    generic map (
dataWidth
    )
    port map (
      s_op1, 
      s_op2,
      s_shiftType,
      s_shiftDirection,
      s_res4
    );

  add1 : entity work.my_gen_n_bit_full_adder
    generic map (
      dataWidth
    )
    port map (
      s_op1,
      s_op2,
      s_cin,
      s_res5,
      s_cout
    );
  slt : entity work.slt 
    generic map(
      dataWidth
    ) 
    port map (
      s_op1,
      s_op2,
      s_res6
    );
  sltu : entity work.sltu
    generic map(
      dataWidth
    )
    port map (
      s_op1,
      s_op2,
      s_res7
    );

  s_clk <= pi_clk;

  process (s_clk) is
  begin

    if rising_edge(s_clk) then
      s_op1 <= pi_op1;
      s_op2 <= pi_op2;
      if (pi_aluOp = AND_ALU_OP) then
        -- AND
        -- begin solution:
        -- end solution!!
      elsif (pi_aluOp = OR_ALU_OP) then
        -- OR
        -- begin solution:
        -- end solution!!
      elsif (pi_aluOp = XOR_ALU_OP) then
        -- XOR
        -- begin solution:
        -- end solution!!
      elsif (pi_aluOp = SLL_ALU_OP) then
        -- SLL
        -- begin solution:
        s_shiftType <= pi_aluOp(opCodeWidth-1);
        s_shiftDirection <= '0';
        -- end solution!!
      elsif (pi_aluOp = SRL_ALU_OP) then
        -- SRL
        -- begin solution:
        s_shiftType <= pi_aluOp(opCodeWidth-1);
		    s_shiftDirection <= '1';
        -- end solution!!
      elsif (pi_aluOp = SRA_OP_ALU) then
        -- SRA
        -- begin solution:
        s_shiftType <= pi_aluOp(opCodeWidth-1);
		    s_shiftDirection <= '1';
        -- end solution!!
      elsif (pi_aluOp = ADD_OP_ALU) then
        -- ADD
        -- begin solution:
        s_cIn <= pi_aluOp(opCodeWidth-1);
        -- end solution!!
      elsif (pi_aluOp = SUB_OP_ALU) then
        -- SUB
        -- begin solution:
        s_cIn <= pi_aluOp(opCodeWidth-1);
        -- end solution!!
      elsif (pi_aluOp = SLT_OP_ALU) then
        -- SLT
        -- begin solution:
          
        -- end solution!!                                                                                                               -- SLT, uses substraction
      elsif (pi_aluOp = SLTU_OP_ALU) then
        -- SLTU
        -- begin solution:
          
        -- end solution!!                                                                                                                -- SLTU, uses substraction
      elsif (pi_aluOp = EQ_OP_ALU) then
      else
        -- OTHERS
        -- begin solution:
      -- end solution!!
      end if;
    end if;

    if falling_edge(s_clk) then
      if (pi_aluOp = AND_ALU_OP) then
        -- AND
        -- begin solution:
        po_aluOut <= s_res3;
	    po_carryOut <= '0';
      -- end solution!!
      elsif (pi_aluOp = OR_ALU_OP) then
        -- OR
        -- begin solution:
        po_aluOut <= s_res2;
	    po_carryOut <= '0';
      -- end solution!!
      elsif (pi_aluOp = XOR_ALU_OP) then
        -- XOR
        po_aluOut <= s_res1;
	    po_carryOut <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SLL_ALU_OP) then
        -- SLL
        po_aluOut <= s_res4;
	    po_carryOut <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SRL_ALU_OP) then
        -- SRL
        po_aluOut <= s_res4;
	    po_carryOut <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SRA_OP_ALU) then
        -- SRA
        po_aluOut <= s_res4;
	    po_carryOut <= '0';
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = ADD_OP_ALU) then
        -- ADD
        po_aluOut <= s_res5;
	    po_carryOut <= s_cOut;
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SUB_OP_ALU) then
        -- SUB
        po_aluOut <= s_res5;
	      po_carryOut <= s_cOut;
        -- begin solution:
      -- end solution!!
      elsif (pi_aluOp = SLT_OP_ALU) then
        -- SLT
        -- begin solution:
        po_aluOut <= s_res6;
        -- end solution!!
      elsif (pi_aluOp = SLTU_OP_ALU) then        
        -- SLTU
        po_aluOut <= s_res7;
        
      elsif (pi_aluOp = EQ_OP_ALU) then
        -- begin solution:
        -- end solution!!
      else
        -- OTHERS
        -- begin solution:
        po_aluOut <= (others => '0');
	    po_carryOut <= '0';
        -- end solution!!
      end if;
    end if;

  end process;

end architecture behavior;
