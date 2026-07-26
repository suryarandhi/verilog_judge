module sign_magnitude_comparator(input signed [7:0] a, input signed [7:0] b, output gt, output eq, output lt);
  assign gt = 1'b0;
  assign eq = 1'b0;
  assign lt = 1'b0;
endmodule
