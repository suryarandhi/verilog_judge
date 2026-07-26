module overflow_detector(input signed [7:0] a, input signed [7:0] b, input signed [7:0] sum, output overflow);
  assign overflow = 1'b0;
endmodule
