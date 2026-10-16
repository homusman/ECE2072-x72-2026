module multiplexer (
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
 


		
		
		