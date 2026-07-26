module zero_detector(input [7:0] a, output is_zero);
  assign is_zero = a == 8'b0;
endmodule
