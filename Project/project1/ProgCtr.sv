
module ProgCtr #(parameter A=10)(
  input                Reset,     // Reset to 0    
                       Start,     // Start Next Program (Not implemented)
                       clk,       
                       beq_flag,   
                       jmp_flag,    
  input        [A-1:0] Target,    // The target line to jump to
  output logic [A-1:0] ProgCtr    
);


logic start_1;
logic running;


// program counter can clear to 0, increment, or jump
always_ff @(posedge clk) begin
  
  start_1 <= Start;
  
  if(Reset)
		begin
			start_1 <= '1;
			running <= '0;
			ProgCtr <= 10'b00_0000_0000;          // reset
		end
  else if(start_1 && ~Start)
		begin
			running <= '1;
		end
  else if((beq_flag || jmp_flag) && running)           // absolute jump to target
		begin
			ProgCtr <= Target;
		end
  else if(running)
		begin
			ProgCtr <= ProgCtr + 10'b00_0000_0001;
		end
  else
		begin
			ProgCtr <= ProgCtr;
		end
  
end

endmodule
