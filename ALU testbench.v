`timescale 1ns / 1ps
module ALU_tb;
	reg  [15:0] input_a;
	reg  [15:0] input_b;
   reg  [2:0]  alu_op;
	reg [15:0] trueValue;
			
	// Outputs are driven so wires are needed:
	
	wire [15:0] modValue; // Module Value
	
	// Control Variables:
	integer count, errors, endFlag;
	 
	initial begin
		  errors = 16'd0;
		  endFlag = 0;
		  count = 0;
  
	end
    
    alu alu_intantitate(
        .input_a(input_a),
        .input_b(input_b),
        .alu_op(alu_op),
        .result(modValue)

    );
	 
	//Need to look into edge cases, Listed:
	// When a and b are zero
	// When a and b cause an overflow
	// Signed overflow
	// When a and b create a negative number
	// ensure a shift is correct when done by a negative input b
	//ensure subtraction is additive when done by a negative input B.
	// multiplying negative and posstive.
	// making sure positive to negative operations are done well
	// Hard coding these:
	
	//move in counts of 10, errorchecking occures every 10 ticks
	initial begin
	//Overflow occurs when the result of a * b, a + b, b << a caused the bits to slip
	//Test largest possible overflow: 15'd
	
	// ----------------------------------------------------------------------
						//Now testing the cases for multiplication:

	$display("--- Multiplication tests ---");
	alu_op = 3'd0;

	//Mult 1: negative * positive
	input_a = -16'd23;
	input_b = 16'd100;
	trueValue = -16'd2300;
	#10;

	//Mult 2: positive * positive
	input_a = 16'd395;
	input_b = 16'd45;
	trueValue = 16'd17775;
	#10;

	//Mult 3: negative * negative
	input_a = -16'd46;
	input_b = -16'd23;
	trueValue = 16'd1058;
	#10;

	//Mult 4: overflow truncation, largest positive values (32767 * 32767)
	input_a = 16'b0111_1111_1111_1111;
	input_b = 16'b0111_1111_1111_1111;
	trueValue = 16'd1;
	#10;

	//Mult 5: overflow truncation, second pattern (32767 * 32752)
	input_a = 16'b0111_1111_1111_1111;
	input_b = 16'b0111_1111_1111_0000;
	trueValue = -16'd32752;
	#10;

	//Mult 6: overflow truncation, negative result (32767 * -32767)
	input_a = 16'b0111_1111_1111_1111;
	input_b = 16'b1000_0000_0000_0001;
	trueValue = -16'd1;
	#10;

	//Mult 7: overflow truncation, all ones (-1 * -1)
	input_a = 16'b1111_1111_1111_1111;
	input_b = 16'b1111_1111_1111_1111;
	trueValue = 16'd1;
	#10;

	//Mult 8: multiplying by zero
	input_a = 16'd0;
	input_b = 16'd1234;
	trueValue = 16'd0;
	#10;

	// ----------------------------------------------------------------------
							//Now testing the cases for addition:

	$display("--- Addition tests ---");
	alu_op = 3'd1;

	//Add 1: negative + positive (and crossing zero)
	input_a = -16'd23;
	input_b = 16'd100;
	trueValue = 16'd77;
	#10;

	//Add 2: positive + positive
	input_a = 16'd395;
	input_b = 16'd45;
	trueValue = 16'd440;
	#10;

	//Add 3: negative + negative
	input_a = -16'd46;
	input_b = -16'd23;
	trueValue = -16'd69;
	#10;

	//Add 4: carry-out discarded, all ones (-1 + -1)
	input_a = 16'b1111_1111_1111_1111;
	input_b = 16'b1111_1111_1111_1111;
	trueValue = -16'd2;
	#10;

	//Add 5: positive overflow (32767 + 32767 wraps to -2)
	input_a = 16'b0111_1111_1111_1111;
	input_b = 16'b0111_1111_1111_1111;
	trueValue = -16'd2;
	#10;

	//Add 6: negative overflow (-32768 + -1 wraps to 32767)
	input_a = -16'd32768;
	input_b = -16'd1;
	trueValue = 16'd32767;
	#10;

	// ----------------------------------------------------------------------
	          //Now testing the cases for subtraction (input_a - input_b):

	$display("--- Subtraction tests ---");
	alu_op = 3'd2;

	//Sub 1: negative - positive
	input_a = -16'd23;
	input_b = 16'd100;
	trueValue = -16'd123;
	#10;

	//Sub 2: positive - positive
	input_a = 16'd395;
	input_b = 16'd45;
	trueValue = 16'd350;
	#10;

	//Sub 3: negative - negative (sign of input_b flipped, -46 + 23)
	input_a = -16'd46;
	input_b = -16'd23;
	trueValue = -16'd23;
	#10;

	//Sub 4: positive - negative (sign of input_b flipped, 100 + 23)
	input_a = 16'd100;
	input_b = -16'd23;
	trueValue = 16'd123;
	#10;

	//Sub 5: positive - larger positive (result crosses zero)
	input_a = 16'd5;
	input_b = 16'd10;
	trueValue = -16'd5;
	#10;

	//Sub 6: equal inputs, all ones (-1 - -1)
	input_a = 16'b1111_1111_1111_1111;
	input_b = 16'b1111_1111_1111_1111;
	trueValue = 16'd0;
	#10;

	//Sub 7: positive overflow (32767 - -1 wraps to -32768)
	input_a = 16'b0111_1111_1111_1111;
	input_b = -16'd1;
	trueValue = -16'd32768;
	#10;

	//Sub 8: negative overflow (-32768 - 1 wraps to 32767)
	input_a = -16'd32768;
	input_b = 16'd1;
	trueValue = 16'd32767;
	#10;
	
		// ----------------------------------------------------------------------
	//Now testing the cases for shifting (input_b shifted by input_a):

	$display("--- Shift tests ---");
	alu_op = 3'd3;

	//Shift 1: shift by zero
	input_a = 16'd0;
	input_b = 16'd3020;
	trueValue = 16'd3020;
	#10;

	//Shift 2: shift by max overflow amount (left by 32767)
	input_a = 16'b0111_1111_1111_1111;
	input_b = 16'b0111_1111_1111_1111;
	trueValue = 16'd0;
	#10;

	//Shift 3: shift by underflow amount (right by 32767)
	input_a = -16'b0111_1111_1111_1111;
	input_b = 16'b0111_1111_1111_1111;
	trueValue = 16'd0;
	#10;

	//Shift 4: shifter is negative (right by 12)
	input_a = -16'd12;
	input_b = 16'b0111_1111_0000_1111;
	trueValue = 16'b0000_0000_0000_0111;
	#10;

	//Shift 5: shiftee is negative (left by 12)
	input_a = 16'd12;
	input_b = 16'b1111_1111_0000_1111;
	trueValue = 16'b1111_0000_0000_0000;
	#10;
	
	//Shift 6: shiftee and shifter are  negative (right by 12)
	input_a = -16'd12;
	input_b = 16'b1111_1111_0000_1111;
	trueValue = 16'b0000_0000_0000_1111;
	#10;
	
	
	//Shift 7: regular shift left
	input_a = 16'd12;
	input_b = 16'd20;
	trueValue = 16'b0100_0000_0000_0000;
	#10;
	
	
	//Shift 8: regular shift right
	input_a = -16'd5;
	input_b = 16'd200;
	trueValue = 16'b0000_0000_0000_0110;
	#10;
	
	endFlag = 1;
  
	end
	

	
	always begin
	#9;
	
		if (endFlag == 1) begin
			if (errors == 0)
				$display("success: All tests passed");
			
			else begin
				$display("Failed, there were %0d errors out of %0d tests", errors, count);       
			end
			$finish;
		end
		
		count = count + 1;
		
		if (trueValue !== modValue) begin
				$display("Failure: Op code was %0d, Input A: %0d, Input B: %0d, Expected output %0d, Module output %0d",  alu_op, input_a, input_b, trueValue, modValue);
				errors = errors + 1;
		end
		#1;
	end
		
	
	
		
endmodule