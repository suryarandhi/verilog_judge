module all_ones_detector_16bit(input [15:0] a, output y);
  assign y = a == {16{1'b1}}};
endmodule
