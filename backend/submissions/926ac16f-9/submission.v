module reduction_or_16bit(input [15:0] a, output y);
  assign y = |a;
endmodule
