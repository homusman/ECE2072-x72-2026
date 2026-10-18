/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual components to be used in 
    the CPU.
/ Worked on: 12/10
	 
Please enter your name and student ID:
James: 33964254
Thomas: 33857288

*/
module sign_extend(input [8:0] in, output [15:0] ext);
	// todo: implement logic to extend sign from 9 bits to 16 bits

	assign ext[8:0] = in[8:0]; // 9th bit is OG sign bit
	assign ext[15:9] = {7{in[8]}}; //pad with 7 bits of whatever the sign bit was to work with 2s complement

endmodule




module tick_FSM(
input rst,
input clk,
input enable,
output [3:0] tick
);
	reg [3:0] current_state;
	reg [3:0] next_state;
	
	// push through next_state into current state
	
	always @(posedge clk) begin
	
	  if (rst) begin 

         current_state <= 4'b0001; // Reset to the initial state

     end else begin 

         current_state <= next_state;  
	  end 
	end 
	
	// next state combinational logic
	always @(*) begin
		case (current_state)
			4'b0001:begin
				if (enable) next_state = 4'b0010;
				else next_state = 4'b0001;
			end
			
			4'b0010:begin
				if (enable) next_state = 4'b0100;
				else next_state = 4'b0010;
			
			end
			
			4'b0100:begin
				if (enable) next_state = 4'b1000;
				else next_state = 4'b0100;
			end
			
			4'b1000:begin
				if (enable) next_state = 4'b0001;
				else next_state = 4'b1000;
			
			end
			
			default:next_state = 4'b0001;
		
		endcase
	end
	
	// output logic: output is exactly the state
	assign tick = current_state;
	
	
endmodule 

module multiplexer(
//These are litteraly wires as they are connected to where these registers are stored somethere else in the cpu.
	input wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7,
	input wire [15:0] SignExtDin,
	input wire [15:0] G,
	input wire [3:0]  sel,
	output reg  [15:0] Bus
);
	always @(*) begin
		case (sel)
			4'd0: Bus = R0;
			4'd1: Bus = R1;
			4'd2: Bus = R2;
			4'd3: Bus = R3;
			4'd4: Bus = R4;
			4'd5: Bus = R5;
			4'd6: Bus = R6;
			4'd7: Bus = R7;
			4'd8: Bus = SignExtDin;
			4'd9: Bus = G;
			default: Bus = 16'd0;
		endcase
	end
endmodule


module ALU(
    input signed [15:0] input_a,
    input  [15:0] input_b,
    input  [2:0]  alu_op,
    output reg [15:0] result
);

    always @(*) begin
        case (alu_op)
            3'd0 : result = input_a * input_b;
            3'd1 : result = input_a + input_b;
            3'd2 : result = input_a - input_b;
				3'd3 : begin
								if (input_a < 0)
									result = input_b >> (-input_a); //negate a to ensure that the correct amount is pushed back
								else
									result = input_b << input_a;
							end
            default : result = 16'bx;
        endcase
    end

endmodule  


module register_n #(parameter N=16) (
    input [N-1:0]data_in,
	 input r_in,
    input clk,
    input rst, // when rst is 1, next clk edge should set Q=0
    output reg[N-1:0] Q
);
	// To set parameter N during instantiation, you can use:
	// register_n #(.N(num_bits)) reg_IR(.....), 
	// where num_bits is how many bits you want to set N to
	// and "..." is your usual input/output signals
  
// todo: implement the logic for the shift register here:
// High level veriloge logic:
                    
always @(posedge clk) begin
// LSB intakes from right and moves down to MSB to the left. This concatination must short buts leftwards.
	
	if (rst) Q <= 0;
	else if(r_in) Q <= data_in;
	
// Q is always full, just with different bits inside. 
	
	
	
end

endmodule

