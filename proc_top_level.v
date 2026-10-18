/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID: 
James: 33964254
Thomas: 33857288

AI declaration:
AI was used to generate the BCD mapping constants
*/

module proc_top_level(
    input  [9:0] SW,
    input  [1:0] KEY,
    output [9:0] LEDR,
    output [6:0] HEX5,
	 output [6:0] HEX0
);

    wire [15:0] bus;
    wire [3:0]  tick;

    simple_proc proc(
        .clk    (~KEY[1]),      // manual clock, KEY is active-low
        .rst    (~KEY[0]),      // synchronous reset
        .enable (1'b1),         // lock processor ON
        .din    (SW[8:0]),
        .bus    (bus),
        .tick   (tick),
        .R0(), .R1(), .R2(), .R3(), .R4(), .R5(), .R6(), .R7(),
		  .IR_DEBUG() );

    assign LEDR = bus[9:0];

    // Tick (one-hot) to 7-seg, active-low segments {g,f,e,d,c,b,a}
    reg [6:0] hex5_r;
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

endmodule