module threshold_detector(input [7:0] a, output above_threshold);
  assign above_threshold = a > 8'd100;
endmodule
