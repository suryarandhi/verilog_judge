module all_ones_detector_8bit(input [7:0] a, output y);
  assign y = a == {8{1'b1}};
endmodule
