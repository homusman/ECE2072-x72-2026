module tick_FSM_top(
    input  wire [1:0] KEY,       // active low
    input  wire [9:0] SW,
    output wire [9:0] LEDR
);
    wire [3:0] tick;

    tick_FSM u_fsm (
        .clk (~KEY[1]),          // rising edge on press
        .rst (~KEY[0]),
        .en  (SW[0]),
        .tick(tick)
    );

    assign LEDR[3:0] = tick;
    assign LEDR[8:4] = 5'b0;
    assign LEDR[9]   = SW[0];
endmodule