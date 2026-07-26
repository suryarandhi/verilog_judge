module nonzero_detector_4bit(input [3:0] a, output y);
  assign y = a != 0;
endmodule
