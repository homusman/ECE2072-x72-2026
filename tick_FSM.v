// Thomas Ma, 6 Oct 2026

module tick_FSM(
input en,
input rst,
input clk,
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
				if (en) next_state = 4'b0010;
				else next_state = 4'b0001;
			end
			
			4'b0010:begin
				if (en) next_state = 4'b0100;
				else next_state = 4'b0010;
			
			end
			
			4'b0100:begin
				if (en) next_state = 4'b1000;
				else next_state = 4'b0100;
			end
			
			4'b1000:begin
				if (en) next_state = 4'b0001;
				else next_state = 4'b1000;
			
			end
			
			default:next_state = 4'b0001;
		
		endcase
	end
	
	// output logic: output is exactly the state
	assign tick = current_state;
	
	
endmodule 