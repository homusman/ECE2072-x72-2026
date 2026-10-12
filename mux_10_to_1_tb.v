`timescale 1ns / 1ps
module mux_10_to_1_tb;
	reg  [15:0] in0, in1, in2, in3, in4;
	reg  [15:0] in5, in6, in7, in8, in9;
	reg  [4:0]  sel;                    
	reg  [15:0] trueValue;       
			
	// Outputs are driven so wires are needed:
	
	wire [15:0] modValue; // Module Value
	
	// Control Variables:
	integer count, errors;
	 
	initial begin
	 
        // Declare first test input/s
        in0 = 16'd0; in1 = 16'd1; in2 = 16'd2; in3 = 16'd3; in4 = 16'd4;
        in5 = 16'd5; in6 = 16'd6; in7 = 16'd7; in8 = 16'd8; in9 = 16'd9;
        sel = 5'b00000;
	end
    
    mux_10_to_1 mux_instantiate (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .DinExtnd(in8),
        .regG(in9),
        .sel(sel),
        .out(modValue)
    );
  
    

	initial begin
		// Initialise control variables:
		errors = 0;
	
	end
	
	always begin
	#10
	sel = sel + 1;
	end
	
	always @(*) begin

	//Should trigger on sel being activated
	                  
		if (sel == 4'd0) 
			trueValue = in0;
			
		else if (sel == 4'd1) 
			trueValue = in1;
			
		else if (sel == 4'd2) 
			trueValue = in2;
			
		else if (sel == 4'd3) 
			trueValue = in3;
			
		else if (sel == 4'd4) 
			trueValue = in4;
			
		else if (sel == 4'd5) 
			trueValue = in5;
			
		else if (sel == 4'd6) 
			trueValue = in6;
			
		else if (sel == 4'd7) 
			trueValue = in7;
			
		else if (sel == 4'd8) 
			trueValue = in8;  // DinExtnd
			
		else if (sel == 4'd9) 
			trueValue = in9;  // regG
			
		else                 
			trueValue = 16'd0;
	
		
	end
	
	always begin
	# 7
	
		if (sel > 4'b1111) begin
			if (errors == 0) begin
				$display("success: %0d tests passed", sel);
			
			end
			else begin
				$display("%0d errors out of %0d tests", errors, sel);
			
			end
		
		$finish;
		
		end
		
		if (trueValue !== modValue) begin
			$display("Failure: Selected line value was %0d, expected output was Input %0d, Module outputted %0d", sel, trueValue, modValue);
			errors = errors + 1;
		
		end

	#3;
		
	end
	
	endmodule