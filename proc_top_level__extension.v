/* 
Monash University ECE2072: Assignment 
This file contains Verilog code to implement the extended version of CPU.

James and Thomas Extension top level module
// Worked on 16/10/2026

James: 33964254
Thomas: 33857288


*/

module proc_top_level__extension(
    input  [9:0] SW,
    input  [1:0] KEY,
    output [9:0] LEDR,
	 output [7:0] HEX0,
    output [7:0] HEX1,
	 output [7:0] HEX2,
	 output [7:0] HEX3,
	 output [7:0] HEX4,
	 output [6:0] HEX5
);

    wire [15:0] bus;
    wire [3:0]  tick;
	 wire [15:0] display_Val;
	 
	 reg [6:0] hex0_r;
	 reg [6:0] hex1_r;
	 reg [6:0] hex2_r;
	 reg [6:0] hex3_r;
	 reg [6:0] hex4_r;
	 reg [6:0] hex5_r;


    proc_extension proc(
        .clk    (~KEY[1]),      // manual clock, KEY is active-low
        .rst    (~KEY[0]),      // synchronous reset
        .enable (SW[9]),         // processor enable is live
        .din    (SW[8:0]),
        .bus    (bus),
        .tick   (tick),
        .R0(), .R1(), .R2(), .R3(), .R4(), .R5(), .R6(), .R7(), .display(display_Val),
		  .IR_DEBUG() );

    assign LEDR = bus[9:0];

    // Tick (one-hot) to 7-seg, active-low segments {g,f,e,d,c,b,a}
    
    always @(*) begin
        case (tick)
            4'b0001: hex5_r = 7'b1111001; // 1
            4'b0010: hex5_r = 7'b0100100; // 2
            4'b0100: hex5_r = 7'b0110000; // 3
            4'b1000: hex5_r = 7'b0011001; // 4
            default: hex5_r = 7'b1000000; // 0 (idle/reset)
        endcase
    end
    assign HEX5 = hex5_r; 
	 
	 wire [15:0]Quo1, Quo2, Quo3, Quo4, Quo5;
	 wire [3:0] rem0, rem1, rem2, rem3, rem4;
	 wire negSign = display_Val[15]; //Gets the sign bit of Rx
	 reg [15:0] magnitude;
	
// bcd divide:
/*
The bcd divide takes in a 16bit wide signal and converts it to a decimal digit to feed into a bcd display    Any whole number divided by 10 will always have a remainder equal to its last digit.
	example: 10,205 through the bcd display:
	
	first signal is 10,205, the bcd divide divides it by 10:
		10,205 / 10 = Quotient = 1020, the remainder is 5
		
		so  5 is fed into the first hex display
		
			1020 / 10 = quotient = 102, remainder is 0
		
		so 0 is fed into the second hex display
		
			102/10 = quotient = 10, remainder is 2
		
		so 2 is fed into the third hex display
		
			10 / 10 = quoitent = 1, remainder is 0
		
		so 0 is fed into the fourth hex display.
		
			1 / 10 = quotient = 0, remainder is 1
		
		so 1 is fed into the 5th hex display
		
			Read these four -> 1 and we read 1 0 2 0 5


*/
	 BinaryCodedDecimal_divide	bcd_divide_inst_1 (
	.denom ( 4'd10 ),
	.numer ( magnitude ),
	.quotient ( Quo1 ),
	.remain ( rem0 )
	);
// bcd divide 2
	BinaryCodedDecimal_divide	bcd_divide_inst_2 (
	.denom ( 4'd10 ),
	.numer ( Quo1 ),
	.quotient ( Quo2 ),
	.remain ( rem1 )
	);
// bcd divide 1
	BinaryCodedDecimal_divide	bcd_divide_inst_3 (
	.denom ( 4'd10 ),
	.numer ( Quo2 ),
	.quotient ( Quo3 ),
	.remain ( rem2 )
	);
// bcd divide 1
	BinaryCodedDecimal_divide	bcd_divide_inst_4 (
	.denom ( 4'd10 ),
	.numer ( Quo3 ),
	.quotient ( Quo4 ),
	.remain ( rem3 )
	);
	
// bcd divide 0
	BinaryCodedDecimal_divide	bcd_divide_inst_5 (
	.denom ( 4'd10 ),
	.numer ( Quo4 ),
	.quotient ( Quo5 ),
	.remain ( rem4 )
	);

	
	//The values must be expressed as unsigned in the case statement. Taking their sign then shifitng:
	
	always @(*) begin
		if (negSign) begin
			magnitude = -display_Val; //Inverts the value to it's postitive sign --> Priority for testbenching 
		/*

	Verilog automatically handles two's complement arithmetic under the hood when using standard operators.
	You can simply use the - prefix operator.
		
		*/
			end
      else begin
			magnitude = display_Val;
		end
   end
	
	
	always @(*) begin
        case (rem0)
            4'b0000: hex0_r = 7'b1000000; // 0
            4'b0001: hex0_r = 7'b1111001; // 1
            4'b0010: hex0_r = 7'b0100100; // 2
            4'b0011: hex0_r = 7'b0110000; // 3
            4'b0100: hex0_r = 7'b0011001; // 4
            4'b0101: hex0_r = 7'b0010010; // 5
            4'b0110: hex0_r = 7'b0000010; // 6
            4'b0111: hex0_r = 7'b1111000; // 7
            4'b1000: hex0_r = 7'b0000000; // 8
            4'b1001: hex0_r = 7'b0010000; // 9
				
            default: hex0_r = 7'b1000000; // 0 (idle/reset)
        endcase
   end
	 
	always @(*) begin
        case (rem1)
            4'b0000: hex1_r = 7'b1000000; // 0
            4'b0001: hex1_r = 7'b1111001; // 1
            4'b0010: hex1_r = 7'b0100100; // 2
            4'b0011: hex1_r = 7'b0110000; // 3
            4'b0100: hex1_r = 7'b0011001; // 4
            4'b0101: hex1_r = 7'b0010010; // 5
            4'b0110: hex1_r = 7'b0000010; // 6
            4'b0111: hex1_r = 7'b1111000; // 7
            4'b1000: hex1_r = 7'b0000000; // 8
            4'b1001: hex1_r = 7'b0010000; // 9
				
            default: hex1_r = 7'b1000000; // 0 (idle/reset)
        endcase
   end
	
	always @(*) begin
        case (rem2)
            4'b0000: hex2_r = 7'b1000000; // 0
            4'b0001: hex2_r = 7'b1111001; // 1
            4'b0010: hex2_r = 7'b0100100; // 2
            4'b0011: hex2_r = 7'b0110000; // 3
            4'b0100: hex2_r = 7'b0011001; // 4
            4'b0101: hex2_r = 7'b0010010; // 5
            4'b0110: hex2_r = 7'b0000010; // 6
            4'b0111: hex2_r = 7'b1111000; // 7
            4'b1000: hex2_r = 7'b0000000; // 8
            4'b1001: hex2_r = 7'b0010000; // 9
				
            default: hex2_r = 7'b1000000; // 0 (idle/reset)
        endcase
   end

	always @(*) begin
       case (rem3)
           4'b0000: hex3_r = 7'b1000000; // 0
           4'b0001: hex3_r = 7'b1111001; // 1
           4'b0010: hex3_r = 7'b0100100; // 2
           4'b0011: hex3_r = 7'b0110000; // 3
           4'b0100: hex3_r = 7'b0011001; // 4
           4'b0101: hex3_r = 7'b0010010; // 5
           4'b0110: hex3_r = 7'b0000010; // 6
           4'b0111: hex3_r = 7'b1111000; // 7
           4'b1000: hex3_r = 7'b0000000; // 8
           4'b1001: hex3_r = 7'b0010000; // 9
				
           default: hex3_r = 7'b1000000; // 0 (idle/reset)
       endcase
   end
	
	always @(*) begin
       case (rem4)
           4'b0000: hex4_r = 7'b1000000; // 0
           4'b0001: hex4_r = 7'b1111001; // 1
           4'b0010: hex4_r = 7'b0100100; // 2
           4'b0011: hex4_r = 7'b0110000; // 3
           4'b0100: hex4_r = 7'b0011001; // 4
           4'b0101: hex4_r = 7'b0010010; // 5
           4'b0110: hex4_r = 7'b0000010; // 6
           4'b0111: hex4_r = 7'b1111000; // 7
           4'b1000: hex4_r = 7'b0000000; // 8
           4'b1001: hex4_r = 7'b0010000; // 9
				
           default: hex4_r = 7'b1000000; // 0 (idle/reset)
       endcase
		 
	// Concatinating the 7th bit to be active lo on if item is negative
		
   end
	
		assign HEX0 = {~negSign, hex0_r};
		assign HEX1 = {~negSign, hex1_r};
		assign HEX2 = {~negSign, hex2_r};
		assign HEX3 = {~negSign, hex3_r};
		assign HEX4 = {~negSign, hex4_r};
				
			
	/* Error checkign code redundance for the task. Archeived as a comment.
	// Opcode to 7-seg, active-low segments {g,f,e,d,c,b,a}
   reg [6:0] hex0_r;
   always @(*) begin
       case (SW[8:6])
           3'd0: hex0_r = 7'b1000000; // 0
           3'd1: hex0_r = 7'b1111001; // 1
           3'd2: hex0_r = 7'b0100100; // 2
           3'd3: hex0_r = 7'b0110000; // 3
           3'd4: hex0_r = 7'b0011001; // 4
           3'd5: hex0_r = 7'b0010010; // 5
           3'd6: hex0_r = 7'b0000010; // 6
           3'd7: hex0_r = 7'b1111000; // 7
       endcase
   end
    assign HEX0 = hex0_r;
*/


endmodule
