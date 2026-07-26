module subtractor_2bit(input [1:0] a, input [1:0] b, output [1:0] diff, output borrow);
  assign diff = a - b;
  assign borrow = a < b;
endmodule
