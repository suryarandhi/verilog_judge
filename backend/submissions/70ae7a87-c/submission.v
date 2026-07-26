module all_ones_detector_3bit(input [2:0] a, output y);
  assign y = a == {3{1'b1}};
endmodule
