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
always_comb DataOut = Acc_Mem;

always_ff @ (posedge clk) begin
	if (Reset) Acc_Mem <= '0;

	if (Write_En) begin
		if (From_Reg) begin 
			Acc_Mem <= RegInput;
		end
		else if (From_ALU) begin
			Acc_Mem <= ALUInput;
		end
		else if (From_Imm) begin
			if(Load_Hi) Acc_Mem[7:4] <= Imm_in;
			else		Acc_Mem[3:0] <= Imm_in;
		end
		else			Acc_Mem <= '0;
	end

end

endmodule

