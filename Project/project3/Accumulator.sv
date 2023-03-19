module Accumulator#(parameter W=8)(
  input                 clk,
                        Reset,
                        Write_En,
						From_Reg,
						From_Imm,
						From_ALU,
						Load_Hi,	// Whether to load the higher 4-bit of acc 
  input       [W-1:0]   RegInput,   // When loading acc with Register value
  input		  [W-1:0]	ALUInput,
  input       [3  :0]   Imm_in,  	// When loading acc with a 4-bit immediate
  output logic[W-1:0]   DataOut		// Outputs what's loaded into acc (for testing puposes)
);

logic [W-1:0]Acc_Mem;				// Stores acc value
assign DataOut = Acc_Mem;

always_ff @ (posedge clk) begin
	if (Reset) begin
		Acc_Mem <= '0;
	end
	else if (Write_En) begin
		case({From_Reg, From_ALU, From_Imm})
			3'b1??: Acc_Mem <= RegInput;
			3'b?1?: Acc_Mem <= ALUInput;
			3'b??1: Acc_Mem <= (Load_Hi) ? {Imm_in, Acc_Mem[3:0]}: {Acc_Mem[7:4], Imm_in}
			default: Acc_Mem <= '0;
		endcase
	end
end

endmodule

