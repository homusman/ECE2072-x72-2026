timescale 1ns / 1ps

module task1_tb();

// instantiate modules-under-test & input output
	// sign extender:
	reg [8:0] sign_extender_input;
	wire [15:0] sign_extender_output;
	sign_extender sign_extender_i(.in(sign_extender_input),.out(sign_extender_output));
	
	initial begin
		sign_extender_input = 0;
	end




endmodule 