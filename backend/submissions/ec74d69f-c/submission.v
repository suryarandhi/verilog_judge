module unsigned_multiplier_4x4(
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] product
);

    // Generate partial products.
    // This perfectly mimics physical AND gates, preventing 'x' 
    // from propagating if one of the input vectors is 0.
    wire [3:0] pp0 = b[0] ? a : 4'b0000;
    wire [3:0] pp1 = b[1] ? a : 4'b0000;
    wire [3:0] pp2 = b[2] ? a : 4'b0000;
    wire [3:0] pp3 = b[3] ? a : 4'b0000;

    // Shift and add the partial products to form the final 8-bit output
    assign product = pp0 + (pp1 << 1) + (pp2 << 2) + (pp3 << 3);

endmodule