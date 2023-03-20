import os.path


# Define operation codes (opcode) for each assembly instruction
OPS = {
    "AND": '00000', "ORR": '00001', "XOR_B": '00010', "XOR_G": '00011',
    "ADD": '00100', "STR": '00101', "LDR": '00110', "CMP": '00111',
    "STA": '01000', "LDA": '01001', "CMP_LS": "01011", "SHL": '01100',
    "SHR": '01101', "SET_H": '01110', "SET_L": '01111', "BEQ": '10000',
    "JMP": '10001', "HLT": '10010', "LD_LUT_H": '10100', "LD_LUT_L": '10101'
}


# Define binary codes for each register
REGS = {
    "R0": '0000', "R1": '0001', "R2": '0010', "R3": '0011',
    "R4": '0100', "R5": '0101', "R6": '0110', "R7": '0111',
    "R8": '1000', "R9": '1001', "R10": '1010', "R11": '1011',
    "R12": '1100', "R13": '1101', "R14": '1110', "R15": '1111'
}


# Define illegal tokens that should be ignored during parsing
ILLEGAL_TOKENS = {"//", "/*", "*/", "*", "#"}


# Define file names for assembly programs and machine code programs
ASSEMBLY_PROGS = ['1_fec_encode.s', '2_fec_decode.s', '3_pattern_match.s']
MACHINE_PROGS = ['prog1_machine.txt', 'prog2_machine.txt', 'prog3_machine.txt']




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
        with open(os.path.join(os.path.dirname(__file__), ASSEMBLY_PROGS[program_idx]), "r") as assembly_code, \
             open(os.path.join(os.path.dirname(__file__), MACHINE_PROGS[program_idx]), "w") as machine_code:


            for line in assembly_code:
                instruction = line.split()
                if not instruction or instruction[0] in ILLEGAL_TOKENS or instruction[0] not in OPS:
                    continue


                parsed_instruction = parse_instruction(instruction)


                if len(parsed_instruction) == 2:
                    machine_line = OPS[parsed_instruction[0]] + parsed_instruction[1]
                else:
                    machine_line = OPS[parsed_instruction[0]] + '0000'


                machine_line += "\n"
                machine_code.write(machine_line)


    except FileNotFoundError:
        print("")


# Assemble each program in the list of assembly programs
for i in range(3):
    assemble_program(i)