module all_ones_detector_2bit(input [1:0] a, output y);
  assign y = a == {2{1'b1}};
endmodule
