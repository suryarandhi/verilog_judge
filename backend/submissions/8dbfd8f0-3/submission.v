module carry_generate_combiner(
    input  [7:0] a,
    input  [7:0] b,
    output g,
    output p
);

assign g = (a + b > 8'hFF);
assign p = &(a ^ b);

endmodule