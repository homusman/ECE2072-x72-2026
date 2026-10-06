`timescale 1ns / 1ps

module components_tb();

// initialise logging variables
	integer count_sign_extender = 0;
	integer errors_sign_extender = 0;

// instantiate modules-under-test & input output
	// sign extender:
	reg signed [8:0] sign_extender_input;
	wire signed [15:0] sign_extender_output;
	
	sign_extender sign_extender_i(.in(sign_extender_input),.out(sign_extender_output));
	
	initial begin
		sign_extender_input = 0;
	end
	
	// tick FSM:
	reg signed [8:0] sign_extender_input;
	wire signed [15:0] sign_extender_output;
	
	sign_extender sign_extender_i(.in(sign_extender_input),.out(sign_extender_output));
	
	initial begin
		sign_extender_input = 0;
	end


// increment sign extender input:
always @(*) begin
# 10
	sign_extender_input = sign_extender_input + 1;
	
	// exit condition
	if (sign_extender_input == 0) begin
		if (errors_sign_extender == 0) begin
			$display("sign extender: passed all %d test cases!", count_sign_extender);
		end 
		else begin
			$display("sign extender: failed with %d errors", errors_sign_extender);
		end
		$stop;
	end
	
end

// check sign extender output:
always @(*) begin
# 9 // wait for output to settle
	// check for correctness by directly comparing if input/output are equal
	// verilog will automatically sign extend unequal length signed. effectively checking if the decimal values are equal
	if (sign_extender_input !== sign_extender_output) begin
		errors_sign_extender = errors_sign_extender + 1;
		$display("sign extender module error! input: %d, output: %d", sign_extender_input, sign_extender_output);
	end
	count_sign_extender = count_sign_extender + 1; //increment for every case checked
	
end



endmodule 