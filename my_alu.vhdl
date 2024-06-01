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
	po_aluOut: out std_logic_vector (dataWidth-1 downto 0);
	po_carryOut: out std_logic;
  po_zero: out std_logic
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
    
    s_cin <= '0' when pi_aluOp = ADD_OP_ALU
             else '1' when pi_aluOp = SUB_OP_ALU;     

    with pi_aluOp select
      po_aluOut <= s_res1 when XOR_ALU_OP,
                   s_res2 when OR_ALU_OP,
                   s_res3 when AND_ALU_OP,
                   s_res4 when SRL_ALU_OP,
                   s_res4 when SLL_ALU_OP,
                   s_res4 when SRA_OP_ALU,
                   s_res5 when ADD_OP_ALU,
                   s_res5 when SUB_OP_ALU,
                   s_res6 when SLT_OP_ALU,
                   s_res7 when SLTU_OP_ALU,
                   (others => '0') when others;
    
    with pi_aluOp select
      s_cout <= '0' when (AND_ALU_OP or OR_ALU_OP or XOR_ALU_OP or SLL_ALU_OP or SRL_ALU_OP or SRA_OP_ALU),
                '1' when others;
        
    po_zero <= '1' when po_aluOut = std_logic_vector(to_unsigned(0, dataWidth))
          else '0';

end architecture behavior;
