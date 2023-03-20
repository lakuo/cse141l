import Definitions::*;

// Parameters:
//  W: length of data input
//  Ops: length of ALU opcode
module ALU #(parameter W=8, Ops=5)(
  input        [W-1:0]   InputA,       // Data inputs
                         InputB,
  input        [Ops-1:0] OP,           // ALU opcode
  output logic [W-1:0]   Out,          // data output
  output logic           Zero          // output = zero flag    !(Out)
);

// type enum: used for convenient waveform viewing
op_mne op_mnemonic;

always_comb begin
  Out = 0; // Nop = default
  case(OP)
    ORR   :  Out = InputA | InputB;      // ( 0) bitwise OR
    XOR_B :  Out = InputA ^ InputB;      // ( 2) bitwise XOR
    XOR_G :  Out = ^InputA;              // ( 3) global (parity) XOR
    AND   :  Out = InputA & InputB;      // ( 4) bitwise AND
    CMP   :  Out = InputA == InputB;     // (12) comparison
	  CMP_LS:  Out = InputA < InputB;      // (13) < comparison
    LSL   :  Out = {InputA[6:0], 1'b0};  // (14) logical shift left
    LSR   :  Out = {1'b0, InputA[7:1]};  // (15) logical shift right
    ADD   :  Out = InputA + InputB;      // (16) add
    default: Out = 8'bxxxx_xxxx;         // Quickly flag illegal ALU Op
  endcase
end

assign Zero = ~|Out;                  // reduction NOR

// Toolchain guard: icarus verilog doesn't support this debug feature.
`ifndef __ICARUS__
always_comb
  op_mnemonic = op_mne'(OP); // displays operation name in waveform viewer
`endif

endmodule