module subtractor_8bit(input [7:0] a, input [7:0] b, output [7:0] diff, output borrow);
  assign diff = a - b;
  assign borrow = a < b;
endmodule
