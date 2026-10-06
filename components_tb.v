timescale 1ns / 1ps

module task1_tb();

// initialise logging variables
	count_sign_extender = 0;
	errors_sign_extender = 0;

// instantiate modules-under-test & input output
	// sign extender:
	reg [8:0] sign_extender_input;
	wire [15:0] sign_extender_output;
	reg signed [15:0] sign_extender_correct_output;
	
	sign_extender sign_extender_i(.in(sign_extender_input),.out(sign_extender_output));
	
	initial begin
		sign_extender_input = 0;
		sign_extender_correct_output = 0;
	end


// increment sign extender input:
always @(*) begin
# 10
	sign_extender_input = sign_extender_input + 1;
	
end

// check sign extender output:
always @(*) begin
# 9 // wait for output to settle
	// calculate the correct output, 
	// based on the fact that the extended input should have the same decimal value as the unextended
	 
	
end



endmodule 