module zero_detector_32bit(input [31:0] a, output y);
  assign y = a == 0;
endmodule
