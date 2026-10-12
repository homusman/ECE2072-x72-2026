`timescale 1ns / 1ps
module register_n_tb;

    // setup wires/registers:
    reg [15:0] expected_val;
	 reg rst;
	 reg r_in;
	 reg clk = 0;
	 reg [15:0] data_in;
	 
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
	 #5
	 clk = ~clk;
	 
	 end

    integer count, errors;

    initial begin
        count = 0;
        errors = 0;
    end
	 
	 // case statement goes here

	 
	 
	 
	 
	 
	 
	 
	 // Does the error checking
    always @(negedge clk) begin
	
        if (count == 9) begin // set to the number of cases
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
			  $display("FAIL: Time %d: Expected %d, Got %d", $time, expected_val, module_val);
			  errors = errors + 1;
			  
        end
        count = count + 1;
		  
    end

endmodule 