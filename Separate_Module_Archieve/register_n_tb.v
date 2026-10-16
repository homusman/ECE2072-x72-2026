`timescale 1ns / 1ps
module register_n_tb;

    // setup wires/registers:
	reg [15:0] expected_val;
	reg rst;
	reg r_in;
	reg clk = 0;
	reg [15:0] data_in;
	reg [1:0]rstRin;	 
	wire [15:0] module_val;

	register_n instantiate_register (
		.data_in (data_in),
		.r_in    (r_in),
		.clk     (clk),	
		.rst     (rst),
		.Q       (module_val)
	);
	 
	 
	 
    // setup clock signal
	always begin
	#10
	clk = ~clk;	
	end
	
	integer count, errors;
	
	initial begin
		count = 0;
		errors = 0;
		rstRin = 2'b11;
		
		rst = 0;
		r_in = 1;
		data_in = $random;
		expected_val = data_in;
		
// Declaring random values to be in the register so that initial case can be evaluated.
		
	end
	
	// case statement goes here
	
	// Testing each op code and rest variation for the register
	// Testing each combination of in_line is considered out of 
	//scope for as brute force would be a lenthy processing time.
	
	// Test cases to consider:
	// Make sure a full register is set to zero for each opcall
	// Make sure each
	
	//rst and rin count goes from 00, to 01 to 10 to 11
	//thats rst = 0 rin = 0, rst = 0 rin = 1, rst = 1 rin = 0, rst = 1, rin = 1;
	
	
// Reading happends on the positive edge, error check happends during the negative edge
	always @(negedge clk) begin
	
		case (count)
// ----------------- Testing that each combination of rst and r_in work with random values ------------------
		1:begin
			rst = rstRin[1];
			r_in = rstRin[0];
// rst is 0 and r_in is 0 so the register holds its value even though data_in changes.
			data_in = $random;
			expected_val = expected_val;
		end
		
		2:begin
			rst = rstRin[1];
			r_in = rstRin[0];
// rst is 0 and r_in is 1 so the new data line is led into the register
			data_in = $random;
			expected_val = data_in;
		end
		
		3:begin
			rst = rstRin[1];
			r_in = rstRin[0];
// rst is 1 and r_in is 0, the register resets to zero regardless of its contents.
			data_in = $random;
			expected_val = 0;
		end
			
		4:begin
			rst = rstRin[1];
			r_in = rstRin[0];
// rst is 1 and r_in is 1, reset takes priority so the register should be zero.
			data_in = $random;
			expected_val = 0;
		end
// --------------------------------------------------------------------------------------------------------	
		endcase
	end
	
// Does the error checking
	always @(posedge clk) begin
	#7
	
		if (count == 5) begin // set to the number of cases
			if (errors == 0) begin
				$display("success");
		end
			else begin
				$display("fail");
			end
			$finish;
			end
		
		
		if (expected_val !== module_val) begin
			
			//Wait for the module to update.
			$display("FAIL on count %0d: Expected %d, Got %d from inputs -> data_in: %0d, rst: %0d and r_in: %0d", count, expected_val, module_val, data_in, rst, r_in);
			errors = errors + 1;
		end
		else begin
			$display("Pass: Expected %d, Got %d from inputs rst: %0d and r_in: %0d", expected_val, module_val, rst, r_in);
		end
		count = count + 1;
		rstRin = rstRin + 1;
		
	#3;
		
	end
	
endmodule 