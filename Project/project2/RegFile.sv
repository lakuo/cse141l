module RegFile #(parameter A=4, W=8)(   // At most 2**A = 16 registers, each register holds W=8 bits
  input     clk,
  input     Reset,
  input     Write_En,
  input			from_ALU,
  input  		from_Acc,
  input			from_Mem,
  input     [A-1:0] address,        // address pointer, comes from Opcode[3:0]
  input     [W-1:0] Mem_Input,      // data from datamemory
  input			[W-1:0] Acc_Input,      //      from accumulator
  input			[W-1:0] ALU_Input,      //      from ALU
  output logic [W-1:0] DataOut      
);

logic [W-1:0] Registers[2**A];      // equivalent to logic [7:0] registers[16]; 


// Combinational reads: Could write `always_comb` block in place of assign
//   Difference: assign is limited to one line of code, so `always_comb` is much more versatile

assign DataOut = Registers[address]; // ARM-style registers (i.e. r0 is general purpose)


/* // FIXME: ^^ Careful! ^^
  You probably don't want different register output ports to behave differently in your final design
  ... or maybe you do, can be a neat trick for more
  compact encoding to have them behave different...
  (but almost certainly not exactly like this)
*/ 



// Sequential (clocked) writes, Works just like data_memory writes
always_ff @ (posedge clk) begin
  integer i;
  if (Reset) begin
    for (i=0; i<2**A; i=i+1) begin
      Registers[i] <= '0;
    end
  end else if (Write_En) begin
	  if(from_ALU) begin
	    Registers[address] <= ALU_Input;
	  end else if (from_Acc) begin
		  Registers[address] <= Acc_Input;
	  end else if (from_Mem) begin
		  Registers[address] <= Mem_Input;
	 end
    
  end
end


endmodule
