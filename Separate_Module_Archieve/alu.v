module alu (
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