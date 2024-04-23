
-- 1. Participant First and Last Name: Jakob Krug
-- 2. Participant First and Last Name: Nicolas Schmidt


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
USE work.constant_package.ALL;

ENTITY my_alu_tb IS
END ENTITY my_alu_tb;

ARCHITECTURE behavior OF my_alu_tb IS

  SIGNAL s_op1 : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_op2 : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_luOut : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_expect : STD_LOGIC_VECTOR(DATA_WIDTH_GEN - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_luOp : STD_LOGIC_VECTOR(ALU_OPCODE_WIDTH - 1 DOWNTO 0) := (OTHERS => '0');
  SIGNAL s_carryOut : STD_LOGIC;
  SIGNAL s_shiftType : STD_LOGIC;
  SIGNAL s_shiftDirection : STD_LOGIC;
  CONSTANT PERIOD : TIME := 10 ns; -- Example: ClockPERIOD of 10 ns
  SIGNAL s_clk : STD_LOGIC := '0';

BEGIN

  lu1 : ENTITY work.my_alu
    GENERIC MAP(DATA_WIDTH_GEN, ALU_OPCODE_WIDTH)
    PORT MAP(
      pi_op1 => s_op1,
      pi_op2 => s_op2,
      pi_aluOp => s_luOp,
      pi_clk => s_clk,
      po_aluOut => s_luOut,
      po_carryOut => s_carryOut
    );

  lu : PROCESS IS
  BEGIN

    s_clk <= '1';
    WAIT FOR PERIOD / 2;
    s_clk <= '0';
    WAIT FOR PERIOD / 2;

    FOR op1_i IN - (2 ** (DATA_WIDTH_GEN - 1)) TO (2 ** (DATA_WIDTH_GEN - 1) - 1) LOOP

      s_op1 <= STD_LOGIC_VECTOR(to_signed(op1_i, DATA_WIDTH_GEN));

      FOR op2_i IN - (2 ** (DATA_WIDTH_GEN - 1)) TO (2 ** (DATA_WIDTH_GEN - 1) - 1) LOOP

        s_op2 <= STD_LOGIC_VECTOR(to_signed(op2_i, DATA_WIDTH_GEN));
        s_clk <= '1';
        WAIT FOR PERIOD / 2;
        s_clk <= '0';
        WAIT FOR PERIOD / 2;
        -- and
        s_luOp <= AND_ALU_OP;
        s_expect <= s_op1 AND s_op2;
        s_clk <= '1';
        WAIT FOR PERIOD / 2;
        s_clk <= '0';
        WAIT FOR PERIOD / 2;
        ASSERT (s_expect = s_luOut)
        REPORT "Had error in AND-Function "
          SEVERITY error;

        -- or
        s_luOp <= OR_ALU_OP;
        s_expect <= s_op1 OR s_op2;
        s_clk <= '1';
        WAIT FOR PERIOD / 2;
        s_clk <= '0';
        WAIT FOR PERIOD / 2;
        ASSERT (s_expect = s_luOut)
        REPORT "Had error in OR-Function "
          SEVERITY error;
        -- xor
        s_luOp <= XOR_ALU_OP;
        s_expect <= s_op1 XOR s_op2;
        s_clk <= '1';
        WAIT FOR PERIOD / 2;
        s_clk <= '0';
        WAIT FOR PERIOD / 2;
        ASSERT (s_expect = s_luOut)
        REPORT "Had error in XOR-Function : " & INTEGER'image(to_integer(signed(s_op1))) & " xor " & INTEGER'image(to_integer(signed(s_op2))) & " = " & INTEGER'image(to_integer(signed(s_luOp))) & " = " & INTEGER'image(to_integer(signed(s_luOut)))
          SEVERITY error;

        IF (op2_i >= 0 AND op2_i < INTEGER(log2(real(DATA_WIDTH_GEN)))) THEN
          -- sll
          s_luOp <= SLL_ALU_OP;
          IF (op2_i <= 0) THEN
            s_expect <= s_op1;
          ELSIF (op2_i < DATA_WIDTH_GEN) THEN
            s_expect(op2_i - 1 DOWNTO 0) <= (OTHERS => '0');
            s_expect(DATA_WIDTH_GEN - 1 DOWNTO op2_i) <= s_op1(DATA_WIDTH_GEN - 1 - op2_i DOWNTO 0);
          END IF;
          s_clk <= '1';
          WAIT FOR PERIOD / 2;
          s_clk <= '0';
          WAIT FOR PERIOD / 2;
          ASSERT (s_expect = s_luOut)
          REPORT "Had error in sll-Function "
            SEVERITY error;

          -- srl
          s_luOp <= SRL_ALU_OP;
          s_expect <= (OTHERS => '0');
          IF (op2_i <= 0) THEN
            s_expect <= s_op1;
          ELSIF (op2_i < DATA_WIDTH_GEN) THEN
            s_expect <= (OTHERS => '0');
            s_expect(DATA_WIDTH_GEN - 1 - op2_i DOWNTO 0) <= s_op1(DATA_WIDTH_GEN - 1 DOWNTO op2_i);
          END IF;
          s_clk <= '1';
          WAIT FOR PERIOD / 2;
          s_clk <= '0';
          WAIT FOR PERIOD / 2;
          ASSERT (s_expect = s_luOut)
          REPORT "Had error in srl-Function "
            SEVERITY error;

          -- sra
          s_luOp <= SRA_OP_ALU;
          IF (op2_i <= 0) THEN
            s_expect <= s_op1;
          ELSIF (op2_i < DATA_WIDTH_GEN) THEN
            s_expect <= (OTHERS => s_op1(DATA_WIDTH_GEN - 1));
            s_expect(DATA_WIDTH_GEN - 1 - op2_i DOWNTO 0) <= s_op1(DATA_WIDTH_GEN - 1 DOWNTO op2_i);
          END IF;
          s_clk <= '1';
          WAIT FOR PERIOD / 2;
          s_clk <= '0';
          WAIT FOR PERIOD / 2;
          ASSERT (s_expect = s_luOut)
          REPORT "Had error in sra-Function"
            SEVERITY error;
        END IF;

        -- add
        s_luOp <= ADD_OP_ALU;
        s_clk <= '1';
        WAIT FOR PERIOD / 2;
        s_clk <= '0';
        WAIT FOR PERIOD / 2;

        IF (((op1_i + op2_i) /= to_integer(signed(s_luOut))) -- Summe mit ALU result vergleichen
          AND ((op1_i + op2_i - 2 ** DATA_WIDTH_GEN) /= (to_integer(signed(s_luOut)))) -- Überlauf prüfen
          AND ((to_integer(signed(s_luOut)) /= (op1_i + op2_i) MOD (2 ** (DATA_WIDTH_GEN))))) THEN
          REPORT INTEGER'image(op1_i) & "+" & INTEGER'image(op2_i) & " ==> " & INTEGER'image(op1_i + op2_i) & " but add-op simulation returns " & INTEGER'image(to_integer(signed(s_luOut)))
            SEVERITY error;
        END IF;

        -- sub
        s_luOp <= SUB_OP_ALU;
        s_clk <= '1';
        WAIT FOR PERIOD / 2;
        s_clk <= '0';
        WAIT FOR PERIOD / 2;

        IF (((op1_i - op2_i) /= to_integer(signed(s_luOut))) AND ((op1_i - op2_i - 2 ** DATA_WIDTH_GEN) /= (to_integer(signed(s_luOut)))) AND ((to_integer(signed(s_luOut)) /= (op1_i - op2_i) MOD (2 ** (DATA_WIDTH_GEN))))) THEN
          REPORT INTEGER'image(op1_i) & "+" & INTEGER'image(op2_i) & " ==> " & INTEGER'image(op1_i + op2_i) & " but sub-op simulation returns " & INTEGER'image(to_integer(signed(s_luOut)))
            SEVERITY error;
        END IF;

      END LOOP;

    END LOOP;

    ASSERT false
    REPORT "end of ALU test"
      SEVERITY note;

    WAIT; --  Wait forever; this will finish the simulation.

  END PROCESS lu;

END ARCHITECTURE behavior;
