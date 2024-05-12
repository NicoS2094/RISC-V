-- Laboratory RA solutions/versuch2
-- Sommersemester 24
-- Group Details
-- Lab Date: 30.04.2024
-- 1. Participant First and Last Name: Jakob Benedikt Krug
-- 2. Participant First and Last Name: Nicolas Schmidt
 
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.Constant_package.all;
  use work.types_package.all;

entity decoder is
-- begin solution:
-- generic(
--     WORD_WIDTH : integer := WORD_WIDTH
-- );
port(
    pi_clk : in std_logic := '0';
    pi_instruction : in std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    po_controlWord : out controlWord := control_word_init
);
-- end solution!!
end entity decoder;


architecture arc of decoder is
-- begin solution:
begin
    process(pi_clk)
    variable v_insFormat : t_instruction_type;
    begin 
        if rising_edge(pi_clk) then
            case pi_instruction(OPCODE_WIDTH - 1 downto 0) is
                when R_OP_INS => v_insFormat := rFormat;
                when I_OP_INS => v_insFormat := iFormat;
                when others => v_insFormat := nullFormat;
            end case;

            case v_insFormat is
                when rFormat => po_controlWord.ALU_OP <= pi_instruction(30) & pi_instruction(14 downto 12);
                when iFormat => po_controlWord <= (
                ALU_OP => pi_instruction(30) & pi_instruction(14 downto 12),
                I_IMM_SEL  => '1',
                J_IMM_SEL  => '0',
                U_IMM_SEL  => '0',
                SET_PC_SEL => '0',
                PC_SEL     => '0',
                IS_BRANCH  => '0',
                CMP_RESULT => '0',
                DATA_CONTROL => (others => '0')
                );
                when others => po_controlWord <= control_word_init;
            end case;
        end if;
    end process;
 -- end solution!!
end architecture;
