module subtractor_3bit(input [2:0] a, input [2:0] b, output [2:0] diff, output borrow);
  assign diff = a - b;
  assign borrow = a < b;
endmodule
