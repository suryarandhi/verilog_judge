module unsigned_multiplier_4x4(
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] product
);

    // Use bitwise AND with replication to mimic physical gates.
    // If 'a' is 0, then 0 & x will deterministically evaluate to 0.
    // If 'b' is 0, then x & 0 will deterministically evaluate to 0.
    wire [3:0] pp0 = a & {4{b[0]}};
    wire [3:0] pp1 = a & {4{b[1]}};
    wire [3:0] pp2 = a & {4{b[2]}};
    wire [3:0] pp3 = a & {4{b[3]}};

    // Shift and add the partial products to form the final 8-bit output
    assign product = pp0 + (pp1 << 1) + (pp2 << 2) + (pp3 << 3);

endmodule