`timescale 1ns / 1ps
module multiplexer_tb;
	reg  [15:0] R0, R1, R2, R3, R4;
	reg  [15:0] R5, R6, R7, SignExtDin, G;
	reg  [4:0]  sel;                    
	reg  [15:0] trueValue;       
			
	// Outputs are driven so wires are needed:
	
	wire [15:0] modValue; // Module Value
	
	// Control Variables:
	integer count, errors;
	 
	initial begin
	 
        // Declare first test input/s
        R0 = 16'd0; R1 = 16'd1; R2 = 16'd2; R3 = 16'd3; R4 = 16'd4;
        R5 = 16'd5; R6 = 16'd6; R7 = 16'd7; SignExtDin = 16'd8; G = 16'd9;
        sel = 5'b00000;
	end
    
    multiplexer mux_instantiate (
        .R0(R0),
        .R1(R1),
        .R2(R2),
        .R3(R3),
        .R4(R4),
        .R5(R5),
        .R6(R6),
        .R7(R7),
        .SignExtDin(SignExtDin),
        .G(G),
        .sel(sel),
        .Bus(modValue)
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
			trueValue = R0;
			
		else if (sel == 4'd1) 
			trueValue = R1;
			
		else if (sel == 4'd2) 
			trueValue = R2;
			
		else if (sel == 4'd3) 
			trueValue = R3;
			
		else if (sel == 4'd4) 
			trueValue = R4;
			
		else if (sel == 4'd5) 
			trueValue = R5;
			
		else if (sel == 4'd6) 
			trueValue = R6;
			
		else if (sel == 4'd7) 
			trueValue = R7;
			
		else if (sel == 4'd8) 
			trueValue = SignExtDin;
			
		else if (sel == 4'd9) 
			trueValue = G;
			
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
			$display("FAIL: Selected line value was %0d, expected output was Input %0d, Module outputted %0d", sel, trueValue, modValue);
			errors = errors + 1;
		end
		else begin
			$display("Pass: Selected line value was %0d, expected output was Input %0d, Module outputted %0d", sel, trueValue, modValue);
		end

	#3;
		
	end
	
	endmodule