module reduction_and_16bit(input [15:0] a, output y);
  assign y = &a;
endmodule
