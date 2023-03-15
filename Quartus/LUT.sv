// Design Name:    CSE141L
// Module Name:    LUT

// possible lookup table for PC target
// leverage a few-bit pointer to a wider number
// Lookup table acts like a function: here Target = f(Addr);
// in general, Output = f(Input)
//
// Lots of potential applications of LUTs!!

// You might consider parameterizing this!
module LUT#(parameter W=10, A=4)(
  input        clk,
				   Reset,
					Write_En,
        			Load_Hi,   // Load higher 2 bits of LUT entry
  input        [ A-1:0] Imm_in,   // Immediate input, used as address for LUT
  input        [ 7:0] Acc_in,   // Accumulator input
  output logic [ 9:0] Target
);


logic [W-1:0] LUT_Mem[2**A];
//assign Addr = Imm_in;
assign Target = LUT_Mem[Imm_in];

always_ff @ (posedge clk) begin
  integer i;
  if (Reset) begin
    for (i=0; i<2**A; i=i+1) 
      LUT_Mem[i] <= '0; 
  end 
  else if (Write_En) begin
    if(Load_Hi) begin
		LUT_Mem[Imm_in][9:8] = Acc_in[1:0];
	 end
	 else begin
		LUT_Mem[Imm_in][7:0] = Acc_in[7:0];
	 end
  end 
 
end



endmodule
