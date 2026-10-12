/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID: 33857288

*/
module simple_proc(
input clk, 
input rst, 
input [8:0] din,
input bus,
output [15:0] R0,
output [15:0] R1,
output [15:0] R2,
output [15:0] R3,
output [15:0] R4,
output [15:0] R5,
output [15:0] R6,
output [15:0] R7);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.
	 
    // ------------------ declare wires: ------------------
		// bus
		wire [15:0] bus;
		
		// register output wires
		 wire [15:0] Q0;
		 wire [15:0] Q1;
		 wire [15:0] Q2;
		 wire [15:0] Q3;
		 wire [15:0] Q4;
		 wire [15:0] Q5;
		 wire [15:0] Q6;
		 wire [15:0] Q7;
		
		 assign R0 = Q0;
		 assign R1 = Q1; 
		 assign R2 = Q2;
		 assign R3 = Q3;
		 assign R4 = Q4;
		 assign R5 = Q5;
		 assign R6 = Q6;
		 assign R7 = Q7;
		 
		 wire [15:0] QA;
		 wire [15:0] QG;
		
		// register enable wires
		wire [15:0] r_in;
		
		wire rA_in;
		wire rG_in;
		
		// sign extender output
		wire ext;
		
		// ALU
		wire [15:0] ALU_out;
		wire [2:0] ALU_op;
		
		// tick_FSM
		wire [3:0] tick_out;

    // ----------------- instantiate registers:-----------------
	 register_n #(.N(16)) Reg0(.data_in(bus), r_in(r_in[0]), .clk(clk), .Q(Q0), .rst(rst));
	 register_n #(.N(16)) Reg1(.data_in(bus), r_in(r_in[1]), .clk(clk), .Q(Q1), .rst(rst));
	 register_n #(.N(16)) Reg2(.data_in(bus), r_in(r_in[2]), .clk(clk), .Q(Q2), .rst(rst));
	 register_n #(.N(16)) Reg3(.data_in(bus), r_in(r_in[3]), .clk(clk), .Q(Q3), .rst(rst));
	 register_n #(.N(16)) Reg4(.data_in(bus), r_in(r_in[4]), .clk(clk), .Q(Q4), .rst(rst));
	 register_n #(.N(16)) Reg5(.data_in(bus), r_in(r_in[5]), .clk(clk), .Q(Q5), .rst(rst));
	 register_n #(.N(16)) Reg6(.data_in(bus), r_in(r_in[6]), .clk(clk), .Q(Q6), .rst(rst));
	 register_n #(.N(16)) Reg7(.data_in(bus), r_in(r_in[7]), .clk(clk), .Q(Q7), .rst(rst));

	 register_n #(.N(16)) RegA(.data_in(bus), r_in(rA_in), .clk(clk), .Q(QA), .rst(rst));
	 register_n #(.N(16)) RegG(.data_in(ALU_out), r_in(rG_in), .clk(clk), .Q(QG), .rst(rst));    
	 
    // ----------------- instantiate sign ext:-----------------
	 
	 sign_extender sign_ext(.in(din),.ext(ext));	 
	 
    // ----------------- instantiate ALU:-----------------
	 
	 ALU alu(.input_a(QA), .input_b(bus), .alu_op(ALU_op), .result(ALU_out));
	 
	 // ----------------- instantiate Multiplexer:-----------------
	 
	 multiplexer mux(.SignExtDin(ext), .R0(Q0), .R1(Q1), .R2(Q2), .R3(Q3), .R4(Q4), .R5(Q5), .R6(Q6), .R7(Q7), .G(QG), .sel(sel), .Bus(bus));
    
    // ----------------- instantiate tick counter:-----------------
	 
	 tick_FSM tick_counter(.rst(rst), .clk(clk), .enable(enable), .tick(tick_out));  
    
    // ----------------- define control unit:-----------------
    
	 always @(posedge clk) begin
        // ----------------- Turn off all control signals:-----------------

			r_in <= 16'b0;
			rA_in <= 0;
			rB_in <= 0;
			
			
        // ----------------- Turn on specific control signals based on current tick:-----------------
        case (/* your counter value goes here */)
            /* Tick 1 */:
                begin
                    // TODO
                end
            
            /* Tick 2 */:
                begin
                    // TODO
                end
            
            /* Tick 3 */:
                begin
                    // TODO
                end
            
            /* Tick 4 */:
                begin
                    // TODO
                end
            
            default:
                begin
                    // TODO
                end

        endcase

    end

endmodule