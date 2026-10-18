/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID: 
James: 33964254
Thomas: 33857288
*/

`timescale 1ns / 1ps

module simple_proc_tb();
	// set up signals
	reg clk;
	reg rst = 0;
	reg enable = 1;
	reg [8:0] din = 0;
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
	
	// instantiate cpu
	simple_proc my_proc(.clk(clk), .rst(rst), .enable(enable), .din(din),.bus(bus),.tick(tick),.R0(R0),.R1(R1),.R2(R2),.R3(R3),.R4(R4),.R5(R5),.R6(R6),.R7(R7));
	
	
	// init logging vars
	integer errors = 0;
	integer i = 9'b0;
	integer j = 9'b0;
	integer k = 9'b0;
	
	// get clocking
	always begin
		clk = 0;
		#5;
		clk = 1;
		#5;
	end
	
	// -------------------------start tests-------------------------
	
	always begin
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
                $display("Error: CPU tick counter doesnt reset");
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
					#10; 
				
					// tick 2: load imm into bus
					din = i; // load number in
					#10; 
				
					// tick 3: load Rx onto bus ( content should be = 0)
					#10;
				
					// tick 4: finish computation and load result int Rx (latches in on next tick)		
					if (bus != i) begin
								errors = errors + 1;
								$display("Error: opcode = 2 (addi) the final result on the bus incorrect. expected %d, got %d", i, bus);
							end
					#10;
				
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
			end

			// test 5: reset clears registers?

			rst = 1;

			#10;

			rst = 0;

			if (tick != 4'b0001) begin
                errors = errors + 1;
                $display("Error: CPU tick counter doesnt reset");
            end
			if (R0 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 0 did not reset");
            end
			if (R1 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 1 did not reset");
            end
			if (R2 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 2 did not reset");
            end
			if (R3 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 3 did not reset");
            end
			if (R4 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 4 did not reset");
            end
			if (R5 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 5 did not reset");
            end
			if (R6 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 6 did not reset");
            end
			if (R7 != 16'b0) begin
                errors = errors + 1;
                $display("Error: register 7 did not reset");
            end

			// test 6: see if add works between all registers. ensure mux is working ok
			for (i = 0; i <= 7; i = i + 1) begin
				for (j = 0; j <= 7; j = j + 1) begin
					// assign inital register values equal to index to easily check if correct pair were added
					// yes possible for incorrect pair to give correct sum but good enough 
					// load Rk = k using movi, one full instruction (4 ticks) per register
						rst = 1;

						#10;
						rst = 0;
					
					for (k = 0; k <= 7; k = k + 1) begin
						// tick 1: load IR (opcode 7 = movi, Rx = k)
						din = {3'd7, k[2:0], 3'b000};
						#10;

						// tick 2: immediate on the bus, saved into Rx
						din = k[8:0];
						#10;

						// ticks 3 & 4: idle
						#20;
					end
					if (i != j) begin
						//tick 1: load IR
						din = {3'd1,i[2:0],j[2:0]};
						#10;

						//tick 2: load Rx
						if (bus != i) begin
							errors = errors + 1;
							$display("Error: bus is not Rx! Should be %d but got %d", i, bus);
						end
						#10

						//tick 3: load Ry
						if (bus != j) begin
							errors = errors + 1;
							$display("Error: bus is not Ry! Should be %d but got %d", j, bus);
						end
						#10

						//tick 4: result
						if (bus != i+j) begin
							errors = errors + 1;
							$display("Error: bus is not Rx + Ry! Sum should be %d but got", i + j, bus);
						end
					end
				end
			end

			// test 7: overflow test



	
	
			
			// finish tb and display total errors
			if (errors == 0) begin
			$display("Success! passed all test cases with no errors");
			end 
			else begin 
			$display("%d errors encountered",errors);
			end
			
			$stop;
	end


endmodule 