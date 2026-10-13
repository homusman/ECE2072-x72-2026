module register_n #(parameter N=16) (
    input [N-1:0]data_in,
	 input r_in,
    input clk,
    input rst, // when rst is 1, next clk edge should set Q=0
    output reg[N-1:0]Q
);
// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals
  
// todo: implement the logic for the shift register here:
// High level veriloge logic:
                    
always @(posedge clk) begin
// LSB intakes from right and moves down to MSB to the left. This concatination must short buts leftwards.
	
	if (rst) begin
		Q <= 0;
	end
	else if (r_in) begin
		Q <= data_in;
	end
	
// Q is always full, just with different bits inside. 
	
	
	
end

endmodule
