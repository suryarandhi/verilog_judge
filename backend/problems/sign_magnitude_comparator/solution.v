module sign_magnitude_comparator(input signed [7:0] a, input signed [7:0] b, output gt, output eq, output lt);
  assign gt = a > b;
  assign eq = a == b;
  assign lt = a < b;
endmodule
