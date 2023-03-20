module RegFile #(parameter A=4, W=8)(   // 2**A registers, each W bits long
  input     clk,
  input     Reset,                  // if enabled, sets all registers to 0
  input     Write_En,               // whether we're writing to a register
  input			from_ALU,               // whether input comes from ALU
  input  		from_Acc,               //                     from Accumulator
  input			from_Mem,               //                     from Memory
  input     [A-1:0] address,        // address pointer, comes from Opcode[3:0]
  input     [W-1:0] Mem_Input,      // data from datamemory
  input			[W-1:0] Acc_Input,      //      from accumulator
  input			[W-1:0] ALU_Input,      //      from ALU
  output logic [W-1:0] DataOut      // value of register $address
);

logic [W-1:0] Registers[2**A];      // equivalent to logic [7:0] registers[16]; 


// Combinational reads: Could write `always_comb` block in place of assign
//   Difference: assign is limited to one line of code, so `always_comb` is much more versatile

assign DataOut = Registers[address]; // ARM-style registers (i.e. r0 is general purpose)

// Sequential writes, works just like data_memory writes
always_ff @ (posedge clk) begin
  // used for iteration through registers on reset
  integer i;
  if (Reset) begin
    // loop through and set all registers to 0
    for (i = 0; i < 2**A; i = i + 1) begin
      Registers[i] <= '0;
    end
  end

  else if (Write_En) begin
    case ({from_ALU, from_Acc, from_Mem})
      // ALU input case
      3'b100, 3'b101, 
      3'b110, 3'b111: Registers[address] <= ALU_Input;
      // Accumulator input case
      3'b010, 3'b011: Registers[address] <= Acc_Input;
      // Memory input case
      default:        Registers[address] <= Mem_Input;
    endcase
	//   if(from_ALU) begin
	//     Registers[address] <= ALU_Input;
	//   end else if (from_Acc) begin
	// 	  Registers[address] <= Acc_Input;
	//   end else if (from_Mem) begin
	// 	  Registers[address] <= Mem_Input;
	//  end
  end
end


endmodule
