`timescale 1ns / 1ps

module components_tb();

// initialise logging variables
	integer count_sign_extender = 0;
	integer errors_sign_extender = 0;
	integer errors_tick_FSM = 0;
	integer i = 0;

// instantiate modules-under-test & input output
	// sign extender:
	reg signed [8:0] sign_extender_input;
	wire signed [15:0] sign_extender_output;
	
	sign_extender sign_extender_i(.in(sign_extender_input),.out(sign_extender_output));
	
	initial begin
		sign_extender_input = 0;
	end

	// tick FSM:
	reg tick_FSM_en;
	reg tick_FSM_rst;
	reg clk;
	wire [3:0] tick_FSM_outputs;

	tick_FSM tick_FSM_i(.en(tick_FSM_en),.rst(tick_FSM_rst),.clk(clk),.tick(tick_FSM_outputs));

	initial begin
		tick_FSM_en = 0;
		tick_FSM_rst = 0;
	end


// free-running clock (10 ns period), needed by clocked modules
    initial clk = 0;
    always #5 clk = ~clk;

// Test cases
    initial begin
        // ===== TEST 1: sign extender (exhaustive, all 512 inputs) =====
        for (i = 0; i < 512; i = i + 1) begin
            sign_extender_input = i[8:0];
            #10; // wait for output to settle

            // both operands are signed, so Verilog sign-extends the narrower one;
            // equality therefore means the decimal values match
            if ($signed(sign_extender_input) !== $signed(sign_extender_output)) begin
                errors_sign_extender = errors_sign_extender + 1;
                $display("sign extender error! input: %0d, output: %0d",
                         sign_extender_input, sign_extender_output);
            end
            count_sign_extender = count_sign_extender + 1;
        end

        if (errors_sign_extender == 0)
            $display("sign extender: passed all %0d test cases!", count_sign_extender);
        else
            $display("sign extender: failed with %0d errors out of %0d cases",
                     errors_sign_extender, count_sign_extender);

        // ===== TEST 2: tick FSM =====
		tick_FSM_rst = 1; // reset the counter prior to testing
		#10; 

		// 1. reset works?
		tick_FSM_rst = 0;
		tick_FSM_en  = 1;
		if (tick_FSM_outputs !== 4'b0001) begin
             errors_tick_FSM = errors_tick_FSM + 1;
             $display("tick FSM error at step 1: got %b", tick_FSM_outputs);
        end
		
        #10

		// 2. 2nd state works? 
		if (tick_FSM_outputs !== 4'b0010) begin
             errors_tick_FSM = errors_tick_FSM + 1;
             $display("tick FSM error at step 2: got %b", tick_FSM_outputs);
        end
        #10

		// 3. 3rd state works? 
		if (tick_FSM_outputs !== 4'b0100) begin
             errors_tick_FSM = errors_tick_FSM + 1;
             $display("tick FSM error at step 3: got %b", tick_FSM_outputs);
        end
        #10

		// 4. 4th state works? 
		if (tick_FSM_outputs !== 4'b1000) begin
             errors_tick_FSM = errors_tick_FSM + 1;
             $display("tick FSM error at step 4: got %b", tick_FSM_outputs);
        end
        #10

		// 5. wraps back to state 1? 
		if (tick_FSM_outputs !== 4'b0001) begin
             errors_tick_FSM = errors_tick_FSM + 1;
             $display("tick FSM error at step 5, didnt wrap back: got %b", tick_FSM_outputs);
        end
		

		// 6. pulling enable low prevents ticking? 
		tick_FSM_en = 0;
        #10

		if (tick_FSM_outputs !== 4'b00001) begin
             errors_tick_FSM = errors_tick_FSM + 1;
             $display("tick FSM error at step 6: got %b", tick_FSM_outputs);
        end

		// summarise tick FSM test results
        if (errors_tick_FSM == 0)
            $display("tick FSM: passed all test cases!");
        else
            $display("tick FSM: failed %d test cases!", errors_tick_FSM);

        $stop;
    end


endmodule 