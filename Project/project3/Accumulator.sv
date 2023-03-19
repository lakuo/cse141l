module Accumulator#(parameter W=8)(
  input		clk,
			Reset,
			Write_En,
			From_Reg,
			From_Imm,
			From_ALU,
			Load_Hi,	// Whether to load the higher 4-bit of acc 
  input       [W-1:0]   RegInput,   // When loading acc with Register value
  input		  [W-1:0]	ALUInput,
  input       [3  :0]   Imm_in,  	// loads acc with a 4-bit immediate
  output logic[W-1:0]   DataOut		
);

logic [W-1:0]Acc_Mem;
assign DataOut = Acc_Mem;

always_ff @ (posedge clk) begin
  if (Reset) begin
    Acc_Mem <= '0;
  end else if (Write_En) begin
    if (From_Reg) begin
      Acc_Mem <= RegInput;
    end else begin
      case ({From_ALU, From_Imm})
        2'b10: Acc_Mem <= ALUInput;
        2'b01: Acc_Mem <= (Load_Hi) ? {Imm_in, Acc_Mem[3:0]} : {Acc_Mem[7:4], Imm_in};
        default: Acc_Mem <= '0;
      endcase
    end
  end
end



endmodule



