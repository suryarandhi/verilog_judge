module nonzero_detector_16bit(input [15:0] a, output y);
  assign y = a != 0;
endmodule
