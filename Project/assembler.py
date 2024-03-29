import os.path

# Define operation codes (opcode) for each assembly instruction
OPS = {
    "ORR":   '00000', "XOR_B": '00001', "XOR_G": '00010', "AND":      '00011', "STR":      '00100', 
    "LDR":   '00101', "STA":   '00110', "LDA":   '00111', "LD_LUT_L": '01000', "LD_LUT_H": '01001', 
    "SET_L": '01010', "SET_H": '01011', "CMP":   '01100', "CMP_LS":   '01101', "LSL":      '01110', 
    "LSR":   '01111', "ADD":   '10000', "BEQ":   '10001', "JMP":      '10010', "HLT":      '10011'
}

# Define binary codes for each register
REGS = {
    "R0":  '0000', "R1":  '0001', "R2":  '0010', "R3":  '0011',
    "R4":  '0100', "R5":  '0101', "R6":  '0110', "R7":  '0111',
    "R8":  '1000', "R9":  '1001', "R10": '1010', "R11": '1011',
    "R12": '1100', "R13": '1101', "R14": '1110', "R15": '1111'
}


# Define illegal tokens that should be ignored during parsing
ILLEGAL_TOKENS = {"//", "/*", "*/", "*", "#"}

# Define file names for assembly programs and machine code programs
ASSEMBLY_PROGS = ['encoder.s', 'decoder.s', 'pattern_match.s']
MACHINE_PROGS = ['machinecode_1.txt', 'machinecode_2.txt', 'machinecode_3.txt']

def parse_instruction(instruction):
    """
    Parse an assembly instruction and replace register names with binary codes.
    """
    result = instruction[:2]

    for token in result:
        token = token.strip(',')
        if token[0] in ILLEGAL_TOKENS:
            result.remove(token)
        elif token[0] == "R":
            result.remove(token)
            result.append(REGS[token])
    return result

def assemble_program(program_idx=0):
    """
    Assemble a program by converting assembly code to machine code.
    """
    try:
        with open(os.path.join(os.path.dirname(__file__), ASSEMBLY_PROGS[program_idx]), "r", encoding="utf-8") as assembly_code, \
     open(os.path.join(os.path.dirname(__file__), MACHINE_PROGS[program_idx]), "w") as machine_code:

            print(f"Assembling program {program_idx + 1}:")
            for line in assembly_code:
                instruction = line.split()
                if not instruction or instruction[0] in ILLEGAL_TOKENS or instruction[0] not in OPS:
                    continue

                print(f"Assembly instruction: {instruction}")
                parsed_instruction = parse_instruction(instruction)
                print(f"Parsed instruction: {parsed_instruction}")

                if len(parsed_instruction) == 2:
                    machine_line = OPS[parsed_instruction[0]] + parsed_instruction[1]
                else:
                    machine_line = OPS[parsed_instruction[0]] + '0000'

                print(f"Machine code: {machine_line}\n")
                machine_line += "\n"
                machine_code.write(machine_line)

    except FileNotFoundError:
        print(f"Error: Assembly program {program_idx + 1} not found.")

# Assemble each program in the list of assembly programs
for i in range(3):
    assemble_program(i)
