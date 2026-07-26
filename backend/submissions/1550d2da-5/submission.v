module carry_generate_combiner(
    input [7:0] a,
    input [7:0] b,
    output g,
    output p
);

wire [8:0] temp;

assign temp = a + b;

assign g = temp[8];      // carry out generated
assign p = &(a ^ b);     // block propagates carry

endmodule