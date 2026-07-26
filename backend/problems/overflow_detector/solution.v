module overflow_detector(input signed [7:0] a, input signed [7:0] b, input signed [7:0] sum, output overflow);
  assign overflow = (a[7] == b[7]) && (sum[7] != a[7]);
endmodule
