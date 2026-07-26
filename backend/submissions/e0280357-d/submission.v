module subtractor_4bit(input [3:0] a, input [3:0] b, output [3:0] diff, output borrow);
  assign diff = a - b;
  assign borrow = a < b;
endmodule
