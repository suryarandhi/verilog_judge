module unsigned_multiplier_4x4(
    input [3:0] a,
    input [3:0] b,
    output [7:0] product
);

wire [7:0] temp;

assign temp = a * b;
assign product = temp;

endmodule