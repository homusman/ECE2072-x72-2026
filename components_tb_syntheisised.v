`timescale 1ns / 1ps

module components_tb_syntheisised();

//Defining global  flags:
	reg sign_tick_done = 0;   // set after sign extender + tick FSM tests finish
	reg alu_done  = 0;   // set after s finish
	reg mux_done  = 0;   // set after multiplexer tests finish
	reg register_done = 0;




// initialise logging variables
	integer sign_extender_count = 0;
	integer sign_extender_errors = 0;
	integer tick_FSM_errors = 0;
	integer i = 0;

// instantiate modules-under-test & input output
	// sign extender:
	reg signed [8:0] sign_extender_input;
	wire signed [15:0] sign_extender_output;
	
	sign_extender sign_extender_i(.in(sign_extender_input),.ext(sign_extender_output));
	
	initial begin
		sign_extender_input = 0;
	end

	// tick FSM:
	reg tick_FSM_en;
	reg tick_FSM_rst;
	reg clk;
	wire [3:0] tick_FSM_outputs;

	tick_FSM tick_FSM_i(.enable(tick_FSM_en),.rst(tick_FSM_rst),.clk(clk),.tick(tick_FSM_outputs));

	initial begin
		tick_FSM_en = 0;
		tick_FSM_rst = 0;
	end


// free-running clock (10 ns period), needed by clocked modules
    initial clk = 0;
    always #5 clk = ~clk;

// Test cases
    initial begin
	 $display("----------------BEGINNING OF SIGN EXTENDER TESTS-------------------");
        // ===== TEST 1: sign extender (exhaustive, all 512 inputs) =====
        for (i = 0; i < 512; i = i + 1) begin
            sign_extender_input = i[8:0];
            #10; // wait for output to settle

            // both operands are signed, so Verilog sign-extends the narrower one;
            // equality therefore means the decimal values match
            if ($signed(sign_extender_input) !== $signed(sign_extender_output)) begin
                sign_extender_errors = sign_extender_errors + 1;
                $display("sign extender error! input: %0d, output: %0d",
                         sign_extender_input, sign_extender_output);
            end
            sign_extender_count = sign_extender_count + 1;
        end

        if (sign_extender_errors == 0)
            $display("sign extender: passed all %0d test cases!\n-------------------------------------------------", sign_extender_count);
        else
            $display("sign extender: failed with %0d errors out of %0d cases\n -------------------------------------------------",
                     sign_extender_errors, sign_extender_count);
$display("\n\n\n----------------BEGINNING OF TICK FSM TESTS-------------------");
        // ===== TEST 2: tick FSM =====
		tick_FSM_rst = 1; // reset the counter prior to testing
		#10; 

		// 1. reset works?
		tick_FSM_rst = 0;
		tick_FSM_en  = 1;
		if (tick_FSM_outputs !== 4'b0001) begin
             tick_FSM_errors = tick_FSM_errors + 1;
             $display("tick FSM error at step 1: got %b", tick_FSM_outputs);
        end
		
        #10

		// 2. 2nd state works? 
		if (tick_FSM_outputs !== 4'b0010) begin
             tick_FSM_errors = tick_FSM_errors + 1;
             $display("tick FSM error at step 2: got %b", tick_FSM_outputs);
        end
        #10

		// 3. 3rd state works? 
		if (tick_FSM_outputs !== 4'b0100) begin
             tick_FSM_errors = tick_FSM_errors + 1;
             $display("tick FSM error at step 3: got %b", tick_FSM_outputs);
        end
        #10

		// 4. 4th state works? 
		if (tick_FSM_outputs !== 4'b1000) begin
             tick_FSM_errors = tick_FSM_errors + 1;
             $display("tick FSM error at step 4: got %b", tick_FSM_outputs);
        end
        #10

		// 5. wraps back to state 1? 
		if (tick_FSM_outputs !== 4'b0001) begin
             tick_FSM_errors = tick_FSM_errors + 1;
             $display("tick FSM error at step 5, didnt wrap back: got %b", tick_FSM_outputs);
        end
		

		// 6. pulling enable low prevents ticking? 
		tick_FSM_en = 0;
        #10

		if (tick_FSM_outputs !== 4'b00001) begin
             tick_FSM_errors = tick_FSM_errors + 1;
             $display("tick FSM error at step 6: got %b", tick_FSM_outputs);
        end

		// summarise tick FSM test results
        if (tick_FSM_errors == 0)
            $display("tick FSM: passed all test cases!\n---------------------------------------------------------");
        else
            $display("tick FSM: failed %d test cases!\n-----------------------------------------------------------", tick_FSM_errors);

        sign_tick_done = 1;
    end
//==========================James' testbenches integration =================================
//	\																												/
//		\																										/
//			\																								/
//				\																						/
//					\																				/
//						\																		/
//							\																/
//								\														/
//									\												/	
//										\										/
//											\								/
//												\						/
//													\				/
//														\		/
//														  \ /
// =====================================================================
	reg  [15:0] input_a;
	reg  [15:0] input_b;
   reg  [2:0]  alu_op;
	reg [15:0] trueValue;
			
	// Outputs are driven so wires are needed:
	
	wire [15:0] modValue; // Module Value
	
	// Control Variables:
	integer alu_count, alu_errors, endFlag_alu, endFlag;
	
	
	
	initial begin
		alu_errors = 16'd0;
		  endFlag_alu = 0;
		  alu_count = 0;
		  endFlag = 0;
  
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
	wait(sign_tick_done);
	$display("\n\n\n----------------BEGINNING OF ALU TESTS-------------------");

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
	// sign tick is done withou alu being one only occurs during the alu testbench which stops the error checkks from evaluating after it's fnished.
	if (sign_tick_done && !alu_done) begin
	
		if (endFlag == 1) begin
			if (alu_errors == 0)
				$display("success: All tests passed--------------------------------------------------------------");
			
			else begin
				$display("Failed, there were %0d errors out of %0d tests------------------------------------------------", alu_errors, alu_count);       
			end
			
			alu_done = 1;
		end
		else begin
		
			alu_count = alu_count + 1;
		
			if (trueValue !== modValue) begin
				$display("Failure: Op code was %0d, Input A: %0d, Input B: %0d, Expected output %0d, Module output %0d",  alu_op, input_a, input_b, trueValue, modValue);
				alu_errors = alu_errors + 1;
			end
			else begin
				$display("PASS: Op code was %0d, Input A: %0d, Input B: %0d, Expected output %0d, Module output %0d",  alu_op, input_a, input_b, trueValue, modValue);
			end
			
		end
	end
		#1;
	end
		
		reg  [15:0] R0, R1, R2, R3, R4;
	reg  [15:0] R5, R6, R7, SignExtDin, G;
	reg  [4:0]  sel;                    
	reg  [15:0] mux_trueValue;      
	
	// Outputs are driven so wires are needed:
	
	wire [15:0] mux_modValue;
	
	// Control Variables:
	integer mux_count, mux_errors; 

	initial begin
	wait(alu_done);
	$display("\n\n\n----------------BEGINNING OF MUX TESTS-------------------");
	end
	
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
        .Bus(mux_modValue)
    );
  
    

	initial begin
		// Initialise control variables:
		mux_errors = 0;
	
	end
	
	always begin
	wait (alu_done);
	#10
	sel = sel + 1;
	end

	// Okay to keep cycling since there will be no input or evaluation so it's just rubbish that isn't affectign any other testbench
	always @(*) begin

	//Should trigger on sel being activated
	                  
		if (sel == 4'd0) 
			mux_trueValue  = R0;       
			
		else if (sel == 4'd1) 
			mux_trueValue  = R1;       
			
		else if (sel == 4'd2) 
			mux_trueValue  = R2;       
			
		else if (sel == 4'd3) 
			mux_trueValue  = R3;       
			
		else if (sel == 4'd4) 
			mux_trueValue  = R4;       
			
		else if (sel == 4'd5) 
			mux_trueValue  = R5;       
			
		else if (sel == 4'd6) 
			mux_trueValue  = R6;       
			
		else if (sel == 4'd7) 
			mux_trueValue  = R7;       
			
		else if (sel == 4'd8) 
			mux_trueValue  = SignExtDin;
			
		else if (sel == 4'd9) 
			mux_trueValue  = G;       
			
		else                 
			mux_trueValue = 16'd0;     
			
		
	end
	
	always begin
	# 7
	if (alu_done && !mux_done) begin
	
		if (sel > 4'b1111) begin
			if (mux_errors == 0) begin
				$display("Success: %0d tests passed-----------------------------------------------------", sel);
			
			end
			else begin
				$display("Failiure: %0d errors out of %0d tests-----------------------------------------------------", mux_errors, sel);
			
			end
		
		mux_done = 1;
		
		end
		else begin
		
			if (mux_trueValue !== mux_modValue) begin
				$display("Failure: Selected line value was %0d, expected output was Input %0d, Module outputted %0d", sel, mux_trueValue, mux_modValue);
				mux_errors = mux_errors + 1;
			end
			else begin
				$display("PASS: Selected line value was %0d, expected output was Input %0d, Module outputted %0d", sel, mux_trueValue, mux_modValue);	
			end
		end
	end

	#3;
		
	end

 // setup wires/registers:
	reg [15:0] expected_val;
	reg rst;
	reg r_in;
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
	 
	
	integer register_count, register_errors;
	
	initial begin
	wait(mux_done)
	$display("\n\n\n----------------BEGINNING OF REGISTER TESTS-------------------");
	end
	
	initial begin
		register_count = 0;
		register_errors = 0;
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
	
		case (register_count)
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
	
	#3
	if (mux_done) begin
		if (register_count == 5) begin // set to the number of cases
			if (register_errors == 0) begin
				$display("Success, All tests passed-------------------------------------------------");
		end
			else begin
				$display("Fail, %0d out of %0d tests failed---------------------------------------------------",mux_errors, mux_count);
			end
			$finish;
			end
		
		
		if (expected_val !== module_val) begin
			
			//Wait for the module to update.
			$display("FAIL on count %0d: Expected %d, Got %d from inputs -> data_in: %0d, rst: %0d and r_in: %0d", register_count, expected_val, module_val, data_in, rst, r_in);
			register_errors = register_errors + 1;
		end
		else begin
			$display("PASS: Expected %d, Got %d from inputs rst: %0d and r_in: %0d", expected_val, module_val, rst, r_in);
		end
		register_count = register_count + 1;
		rstRin = rstRin + 1;
	end
		
	#2;
		
	end
	


endmodule