module comparator_3bit(input [2:0] a, input [2:0] b, output gt, output eq, output lt);
  assign gt = a > b;
  assign eq = a == b;
  assign lt = a < b;
endmodule
