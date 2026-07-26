module reduction_and_32bit(input [31:0] a, output y);
  assign y = &a;
endmodule
