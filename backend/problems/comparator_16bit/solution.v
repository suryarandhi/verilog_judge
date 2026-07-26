module comparator_16bit(input [15:0] a, input [15:0] b, output gt, output eq, output lt);
  assign gt = a > b;
  assign eq = a == b;
  assign lt = a < b;
endmodule
