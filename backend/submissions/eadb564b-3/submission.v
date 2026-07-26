module all_ones_detector_32bit(input [31:0] a, output y);
  assign y = a == {32{1'b1}}};
endmodule
