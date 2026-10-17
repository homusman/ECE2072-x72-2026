/*
Monash University ECE2072: Assignment 
This file contains Verilog code to implement individual the CPU.

Please enter your student ID: 33857288

*/
module simple_proc(
input clk, 
input rst, 
input enable,
input [8:0] din,
output [15:0] bus,
output [3:0] tick,
output [15:0] R0,
output [15:0] R1,
output [15:0] R2,
output [15:0] R3,
output [15:0] R4,
output [15:0] R5,
output [15:0] R6,
output [15:0] R7,
output [8:0] IR_DEBUG);

    // Note: The skeleton you are provided with includes output ports to output the values of the internal registers R0 - R7, for the purpose of test benching. When instantiating the processor to program your DE10-lite, you can leave these ports unused.
	 
    // ------------------ declare wires: ------------------
		
		// register output wires --> Clear port name notion but redundant code.
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
		reg [7:0] r_in;
		
		reg rA_in;
		reg rG_in;
		
		// sign extender output
		wire [15:0] ext;
		
		// ALU
		wire [15:0] ALU_out;
		reg [2:0] ALU_op;
		
		// mux
		reg [3:0] sel;
		
		// tick_FSM
		wire [3:0] tick_out;
		
		// Instruction register
		reg rIR_in;
		wire [8:0] QIR;
		
		reg [2:0]opcode; // James -> Added for compiler to read top to bottom
		assign IR_DEBUG = {sel, opcode, 3'b0};


    // ----------------- instantiate registers:-----------------
	 register_n #(.N(16)) Reg0(.data_in(bus), .r_in(r_in[0]), .clk(clk), .Q(Q0), .rst(rst));
	 register_n #(.N(16)) Reg1(.data_in(bus), .r_in(r_in[1]), .clk(clk), .Q(Q1), .rst(rst));
	 register_n #(.N(16)) Reg2(.data_in(bus), .r_in(r_in[2]), .clk(clk), .Q(Q2), .rst(rst));
	 register_n #(.N(16)) Reg3(.data_in(bus), .r_in(r_in[3]), .clk(clk), .Q(Q3), .rst(rst));
	 register_n #(.N(16)) Reg4(.data_in(bus), .r_in(r_in[4]), .clk(clk), .Q(Q4), .rst(rst));
	 register_n #(.N(16)) Reg5(.data_in(bus), .r_in(r_in[5]), .clk(clk), .Q(Q5), .rst(rst));
	 register_n #(.N(16)) Reg6(.data_in(bus), .r_in(r_in[6]), .clk(clk), .Q(Q6), .rst(rst));
	 register_n #(.N(16)) Reg7(.data_in(bus), .r_in(r_in[7]), .clk(clk), .Q(Q7), .rst(rst));

	 register_n #(.N(16)) RegA(.data_in(bus), .r_in(rA_in), .clk(clk), .Q(QA), .rst(rst));
	 register_n #(.N(16)) RegG(.data_in(ALU_out), .r_in(rG_in), .clk(clk), .Q(QG), .rst(rst));    
	 
    // ----------------- instantiate sign ext:-----------------
	 
	 sign_extend sign_ext(.in(din),.ext(ext));	 
	 
    // ----------------- instantiate ALU:-----------------
	 
	 ALU alu(.input_a(QA), .input_b(bus), .alu_op(ALU_op), .result(ALU_out));
	 
	 // ----------------- instantiate Multiplexer:-----------------
	 
	 multiplexer mux(.R0(Q0), .R1(Q1), .R2(Q2), .R3(Q3), .R4(Q4), .R5(Q5), .R6(Q6), .R7(Q7), .SignExtDin(ext), .G(QG), .sel(sel), .Bus(bus));
    
    // ----------------- instantiate tick counter:-----------------
	 
	 tick_FSM tick_counter(.rst(rst), .clk(clk), .enable(enable), .tick(tick_out));  
	 
    assign tick = tick_out;
	 
	 // ----------------- instantiate instruction register:-----------------
	 
	 register_n #(.N(9)) RegIR(.data_in(din), .r_in(rIR_in), .clk(clk), .Q(QIR), .rst(rst));
    
    // ----------------- define control unit:-----------------
	 //this simple processesor implements these four commands
	 //7 - Move immediate (movi)
	 //1 - Addition (add)
	 //2 - Add Immediate (addi)
	 //3 - Subtraction (sub)
	
	 // note: the following are driven by the combinational logic block below
    reg type; // 0 -> type 1, 1 -> type 2

	 reg [2:0] Rx; // addr of first register to access
	 reg [2:0] Ry; // addr of 2nd  register to access
	 assign IR_DEBUG = {sel, opcode, 3'b0};
	 	 
	 // CU control logic (note that this is entirely combinational logic driven by the tick_FSM state
	 always @(*) begin
        // ----------------- Turn off all control signals:-----------------

			r_in = 16'b0;
			rA_in = 0;
			rG_in = 0;
			rIR_in = 0;
			sel = 4'd8; // default to DIN on the bus
			ALU_op = 2'd0;
			
			
        // ----------------- Turn on specific control signals based on current tick:-----------------
        case (tick_out) 
            /* Tick 1 */
                4'b0001 : begin
						  rIR_in = 1;
                end
            
            /* Tick 2 */
                4'b0010 : begin
						  if (opcode == 1 || opcode == 3 || opcode == 4) begin
						   // place Rx onto bus
							sel = Rx;
							
							// enable register A
							rA_in = 1;
							
						  end else if (opcode == 2 || opcode == 5 )  begin
							// place DIN onto bus
							sel = 4'd8;
							
							// enable register A
							rA_in = 1;
													  
						  end else if (opcode == 7) begin
						   // put DIN onto the bus and save it into Rx
							sel = 4'd8;
						   r_in[Rx] = 1;
						  end
						  
                end
            
            /* Tick 3 */
                4'b0100 : begin
                    if (opcode == 1 || opcode == 3 || opcode == 4) begin
						   // place Ry's value onto the bus
							sel = Ry;
							
							// set the ALU operation
							case(opcode)
								1: ALU_op = 1;
								2: ALU_op = 1;
								3: ALU_op = 2;
								4: ALU_op = 0;
								5: ALU_op = 3;
								default: ALU_op = 1; // arbitrarily set operation as 1 as default for non ALU instructions
							endcase
							
							// get the result into reg G
							rG_in = 1;
							
						  end else if (opcode == 2 || opcode == 5 ) begin
							// place Rx's value onto the bus
							sel = Rx;
							
							// set the ALU operation
							case(opcode)
								1: ALU_op = 1;
								2: ALU_op = 1;
								3: ALU_op = 2;
								4: ALU_op = 0;
								5: ALU_op = 3;
								default: ALU_op = 1; // arbitrarily set operation as 1 as default for non ALU instructions
							endcase
							
							// get the result into reg G
							rG_in = 1;
							
						  end
                end
            
            /* Tick 4 */
                4'b1000 : begin
                    if (opcode == 1 || opcode == 3 || opcode == 4) begin
							// put G onto bus
							sel = 9;
							
							// save the result back to Rx
							r_in[Rx] = 1;
							
						  end else if (opcode == 2 || opcode == 5) begin
							// put G onto bus
							sel = 9;
							
							// save the result back to Rx
							r_in[Rx] = 1;
													  
						  end
                end
            
            default:
                begin
                    // TODO
                end

        endcase

    end
	 
	 // combinational logic for decoding contents of IR
	 always @(*) begin
		 opcode = QIR[8:6];
		 Rx = QIR[5:3];
		 Ry = QIR[2:0]; // unused for type 2, redundant for those cases
 
	 end

endmodule