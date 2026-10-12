// citation: the following code is re-used from Lab 2 exercise Task: E, written by Thomas Ma


module sign_extender (
    input signed [8:0] in,
    output signed [15:0] ext
);

// todo: implement logic to extend sign from 9 bits to 16 bits

assign ext[8:0] = in[8:0]; // 9th bit is OG sign bit
assign ext[15:9] = {7{in[8]}}; //pad with 7 bits of whatever the sign bit was to work with 2s complement

endmodule
