`timescale 1ns / 1ps

module proc_extension_tb();
	// set up signals
	reg clk;
	reg rst = 0;
	reg enable = 1;
	reg [8:0] din = 0;
	reg simple_tb_done = 0;
	wire signed [15:0] bus;
	wire [3:0] tick;
	wire signed [15:0] R0;
	wire signed [15:0] R1;
	wire signed [15:0] R2;
	wire signed [15:0] R3;
	wire signed [15:0] R4;
	wire signed [15:0] R5;
	wire signed [15:0] R6;
	wire signed [15:0] R7;
	wire signed [15:0] display;

	
	// instantiate cpu
	proc_extension procExt_1(.clk(clk), .rst(rst), .enable(enable), .din(din),.bus(bus),.tick(tick),.R0(R0),.R1(R1),.R2(R2),.R3(R3),.R4(R4),.R5(R5),.R6(R6),.R7(R7),.display(display_val);
	
	
	// init logging vars
	integer errors = 0;
	integer i = 9'b0;
	integer j = 9'b0;
	
	// get clocking
	always begin
		clk = 0;
		#5;
		clk = 1;
		#5;
	end
	
	// -------------------------start tests-------------------------
	
	initial begin
		// test 1: check that enable works
		enable = 0;
		#40
		if (tick != 4'b0001) begin
                errors = errors + 1;
                $display("Error: CPU not halted by enable = 0");
            end
		
		// test 2: check that enable works
		enable = 1;
		#10;
		if (tick != 4'b0010) begin
                errors = errors + 1;
                $display("Error: CPU wont enable with enable = 1");
            end

		// test 3: check that rst works
		enable = 1;
		rst = 1;
		#10;
		if (tick != 4'b0001) begin
                errors = errors + 1;
                $display("Error: CPU doesnt reset");
            end
		
		// test 4: mixed ALU tests (exhaustive);
		// this tests addi with Rx = {R0, R1} and any of the 2^9 possible immediate values, assuming R0 and R1 are initialised at 0.
		// it also tests the addition operation R0 + R1 for the 2^9 possible starting values in each of R0 and R1
		for (i = -256; i <= 255; i = i + 1) begin
			for (j = -256; j <= 255; j = j + 1) begin
				// part 0: reset core
					rst = 1;
					#10;

				// part 1: addi to load a number into R0
					// tick 1: load IR
					rst = 0;
					din = 9'b010000000; // Opcode = 2, Rx = 0
					#10; // Tick one - tick two
				
					// tick 2: load imm into bus
					din = i; // load number in
					#10; //tick two to tick three
				
					// tick 3: load Rx onto bus ( content should be = 0)
					#10; // tich three to tick four
				
					// tick 4: finish computation and load result int Rx (latches in on next tick)		
					if (bus != i) begin
								errors = errors + 1;
								$display("Error: opcode = 2 (addi) the final result on the bus incorrect. expected %d, got %d", i, bus);
							end
					#10; // tick four back to tick one.
				
					// tick 1: check that the results did load into Rx
					if (R0 != i) begin
								errors = errors + 1;
								$display("Error: opcode = 2 (addi) doesnt save result into R0. expected R0 = %d, got %d", i, R0);
							end
			
				// part 2: addi to load a number into R1
					// still tick 1: load IR
					rst = 0;
					din = 9'b010001000; // opcode = 2, Rx = 1
					#10; 
				
					// tick 2: load imm into bus
					din = j; // load 2nd number in 
					#10; 
					
					// tick 3: load Rx onto bus
					#10;
					
					// tick 4: finish computation and load result int Rx (latches in on next tick)		
					if (bus != j) begin
								errors = errors + 1;
								$display("Error: opcode = 2 (addi) the final result on the bus incorrect. expected %d, got %d", j, bus);
							end
					#10;
					
					// tick 1: check that the results did load into Rx
					if (R1 != j) begin
								errors = errors + 1;
								$display("Error: opcode = 2 (addi) doesnt save result into R1. expected R0 = %d, got %d", j, R1);
							end
						
				// part 3: add Rx = 0 and Ry = 1;
					// tick 1: load IR
					rst = 0;
					din = 9'b001000001; // opcode = 1, Rx = 0, Ry = 1
					#10; 
					
					// tick 2: Rx being loaded onto bus 
					#10; 
					
					// tick 3: load Ry onto bus
					#10;
					
					// tick 4: finish computation and load result into Rx (latches in on next tick)		
					if (bus != i + j) begin
								errors = errors + 1;
								$display("Error: opcode = 1 (add) the final result on the bus is incorrect. Expected %d, got %d", i + j, bus);
							end
					#10;
					
					// tick 1: check that the results did load into Rx
					if (R0 != i + j) begin
								errors = errors + 1;
								$display("Error: opcode = 1 (add) doesnt save the correct result into R0. Expected %d, got %d", i+j, R0);
							end
				end
				
				//Tick 1: Reset the processor to an empty state.
					rst = 1;
				#10; // Reset doesn't count as a clock cycle, back to tick one.
					rst = 0;
			for (i = 9'b0; i <= 9'b111111111) begin
				for (k = -256; k <= 255; i++) begin
			 // En	 Op   Rx	  Ry
				din = {1'b1,3'b111,k,3'b000}; // din is the muvi instruction concatinated with succesivly larger registers.
				#10; // Tick one specified the register.
			
				din = {1'b1,i}; // SW is the muvi instruction concatinated with succesivly larger values from -256 up to 255.
				#10 // Tick two specified the value being moved into the register.
				
				#10; // Tick three idle
				#10; // Tick four idle
				
				end
				//All Registers have been loaded with a value
				
				//Check one, all register equal the same value checked beside all register equaling the expected value
				if (R0 != R1 != R2 != R3 != R4 != R5 != R6 != R7!) begin
					$display("Error: Registers do not match, Value contained should be:, Values contained instead are:  "l
			end
			
		
					
				
		
			
				
			// finish tb and display total errors
			if (errors == 0) begin
			$display("Success! passed all test cases with no errors");
			end 
			else begin 
			$display("%d errors encountered",errors);
			end
			
			
			
	end
	
/* Extention Test cases: All matters of top level synthesis are for hardware testing, for example
		
		The display functionality of the hex display.


*/
			


	reg  [9:0] SW;       // SW[9] = enable, SW[8:0] = DIN
	reg  [1:0] KEY = 2'b11;       // active-low: 1 = not pressed
	wire [9:0] LEDR;
	wire [7:0] HEX0, HEX1, HEX2, HEX3, HEX4;   // bit 7 = decimal point
	wire [6:0] HEX5;                           // tick display
	reg [3:0] DecVal_0;
	reg [3:0] DecVal_1;
	reg [3:0] DecVal_2;
	reg [3:0] DecVal_3;
	reg [3:0] DecVal_4;
	reg [3:0] DecVal_5;
	reg [4:0] expected_hex;
	reg[4:0] module_hex;
	wire clock = KEY[1]
	
	

	proc_top_level__extension topLvlInstant (
		.SW(SW),
		.KEY(KEY),
		.LEDR(LEDR),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5)
	);

// Test One, display functionality. Cycle through every value of Rx into RH and make sure it outputs the correct value.
// Assign a decimal number to the hex outputs and make sure that they are outputted correctly.
	always @(*) begin
	
		case (Hex0)
			   7'b1000000: DecVal_0 = 0; // 0
            7'b1111001: DecVal_0 = 1; // 1
            7'b0100100: DecVal_0 = 2; // 2
            7'b0110000: DecVal_0 = 3; // 3
            7'b0011001: DecVal_0 = 4; // 4
            7'b0010010: DecVal_0 = 5; // 5
            7'b0000010: DecVal_0 = 6; // 6
            7'b1111000: DecVal_0 = 7; // 7
            7'b0000000: DecVal_0 = 8; // 8
            7'b0010000: DecVal_0 = 9; // 9
		end
		
		case (Hex1)
			   7'b1000000: DecVal_1 = 0; // 0
            7'b1111001: DecVal_1 = 1; // 1
            7'b0100100: DecVal_1 = 2; // 2
            7'b0110000: DecVal_1 = 3; // 3
            7'b0011001: DecVal_1 = 4; // 4
            7'b0010010: DecVal_1 = 5; // 5
            7'b0000010: DecVal_1 = 6; // 6
            7'b1111000: DecVal_1 = 7; // 7
            7'b0000000: DecVal_1 = 8; // 8
            7'b0010000: DecVal_1 = 9; // 9
		end
		
		case (Hex2)
			   7'b1000000: DecVal_2 = 0; // 0
            7'b1111001: DecVal_2 = 1; // 1
            7'b0100100: DecVal_2 = 2; // 2
            7'b0110000: DecVal_2 = 3; // 3
            7'b0011001: DecVal_2 = 4; // 4
            7'b0010010: DecVal_2 = 5; // 5
            7'b0000010: DecVal_2 = 6; // 6
            7'b1111000: DecVal_2 = 7; // 7
            7'b0000000: DecVal_2 = 8; // 8
            7'b0010000: DecVal_2 = 9; // 9
		end
		
		case (Hex3)
			   7'b1000000: DecVal_3 = 0; // 0
            7'b1111001: DecVal_3 = 1; // 1
            7'b0100100: DecVal_3 = 2; // 2
            7'b0110000: DecVal_3 = 3; // 3
            7'b0011001: DecVal_3 = 4; // 4
            7'b0010010: DecVal_3 = 5; // 5
            7'b0000010: DecVal_3 = 6; // 6
            7'b1111000: DecVal_3 = 7; // 7
            7'b0000000: DecVal_3 = 8; // 8
            7'b0010000: DecVal_3 = 9; // 9
		end
		
		case (Hex4)
			   7'b1000000: DecVal_4 = 0; // 0
            7'b1111001: DecVal_4 = 1; // 1
            7'b0100100: DecVal_4 = 2; // 2
            7'b0110000: DecVal_4 = 3; // 3
            7'b0011001: DecVal_4 = 4; // 4
            7'b0010010: DecVal_4 = 5; // 5
            7'b0000010: DecVal_4 = 6; // 6
            7'b1111000: DecVal_4 = 7; // 7
            7'b0000000: DecVal_4 = 8; // 8
            7'b0010000: DecVal_4 = 9; // 9
		end
	end
	
// ----------- TEST FOR CORRECT ENCODING OF VALUES ONTO THE HEX -- BRUTE FORCE ---------------------------	
	
// Load in muvi instruction into the reguster followed by a display command for each itteration of possible Rx values

		always begin
			//Load the Muvi opcode into a random register and assign display to that register for every opcode
			for (i = -32768; i <= 32767; i++) begin
			//Forcing in the display val to bypass instruction writing. Tests display_val and the bcd decoders
				force topLvlInstant.display_Val = i;
				expected_hex = i;
				
				// rebuild the displayed number from its digits
				module_value = DecVal_4 * 10000 + DecVal_3 * 1000 + DecVal_2 * 100 + DecVal_1 * 10 + DecVal_0;

				// decimal points are active-low: 0 means lit, meaning the value is negative
				if (HEX0[7] == 1'b0) begin
					module_hex = -module_hex;
				end
				
				if (module_hex! == expected_hex) begin
					
					$display("Error: Expected Hex display = %0d. Value displayed on Hex = %0d", expected_hex, module_hex);
					error = 1;
					
				end
		
				release topLvlInstant.display_Val; 	
			 
			end
		end
	/*	
		always begin
			//Load the Muvi opcode into a random register and assign display to that register for every opcode
			for (i = 9'b0; i <= 9'b111111111) begin
				for (k = 3'b000; k <= 3'b111; i++) begin
			//Forcing in the display val to bypass instruction writing. Tests display_val and the bcd decoders
				 // En	 Op   Rx	  Ry
			SW = {1'b1,3'b111,k,3'b000} // SW is the muvi instruction concatinated with succesivly larger registers.
			clock = 0
			clock = 1
			
			SW = {1'b1,k} // SW is the muvi instruction concatinated with succesivly larger values up to 25.
			clock = 0
			clock = 1
			SW = {1'b1,3'b0,k,3'b000}
			clock 0;
			clock 1;
		// SW Will display onto the Hex and the readout is presented as HEX0...HEX5
			expected_hex = i;
				
				// rebuild the displayed number from its digits
			module_value = DecVal_4 * 10000 + DecVal_3 * 1000 + DecVal_2 * 100 + DecVal_1 * 10 + DecVal_0;

				// decimal points are active-low: 0 means lit, meaning the value is negative
				if (HEX0[7] == 1'b0) begin
					module_hex = -module_hex;
				end
				
				if (module_hex! == expected_hex) begin
					
					$display("Error: Expected Hex display = %0d. Value displayed on Hex = %0d", expected_hex, module_hex);
					error = 1;
					
				end
			
			 
				end
			end
		end
		
			
	*/		
			
			


endmodule

