module ProgCtr #(parameter A=10)(
  input        Reset,     // Reset to 0
               clk,       
               beq_flag,   
               jmp_flag,    
  input        [A-1:0] Target,    // The target line to jump to
  output logic [A-1:0] ProgCtr    
);

logic running;

// program counter can clear to 0, increment, or jump
always_ff @(posedge clk) begin
  if (Reset) begin
    running <= '0;
    ProgCtr <= '0;          // reset
  end else if (~running && ~Reset) begin
    running <= '1;          // start running
  end else if (beq_flag || jmp_flag) begin
    ProgCtr <= Target;      // absolute jump to target
  end else if (running) begin
    ProgCtr <= ProgCtr + 1; // increment
  end
end

endmodule




