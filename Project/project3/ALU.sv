// Module Name:    ALU
// Project Name:   CSE141L
//
// Additional Comments:
//   combinational (unclocked) ALU

//includes package "Definitions"
import Definitions::*;

module ALU #(parameter W=8, Ops=5)(
  input        [W-1:0]   InputA,       // Data inputs
                         InputB,
  input        [Ops-1:0] OP,           // ALU opcode, part of microcode
  output logic [W-1:0]   Out,          // data output
  output logic           Zero          // output = zero flag    !(Out)
);

// type enum: used for convenient waveform viewing
op_mne op_mnemonic;

always_comb begin
  Out = 0; // No Op = default
  case(OP)
    ADD   : Out = InputA + InputB;        // (4 ) add 
    CMP   : Out = InputA == InputB;       // (7 ) comparison
	  CMP_LS: Out = InputA < InputB;
    AND   : Out = InputA & InputB;        // (0 ) bitwise AND
    ORR   : Out = InputA | InputB;        // (1 ) bitwise OR
    XOR_B : Out = InputA ^ InputB;        // (2 ) bitwise XOR
    XOR_G : Out = ^InputA;                // (3 ) global (reduction) XOR
    SHL   : Out = {InputA[6:0], 1'b0};    // (12) logical shift left
    SHR   : Out = {1'b0, InputA[7:1]};    // (13) logical shift right
    default : Out = 8'bxxxx_xxxx;        // Quickly flag illegal ALU Op
  endcase
end

assign Zero   = ~|Out;                  // reduction NOR

// Toolchain guard: icarus verilog doesn't support this debug feature.
`ifndef __ICARUS__
always_comb
  op_mnemonic = op_mne'(OP);            // displays operation name in waveform viewer
`endif

endmodule