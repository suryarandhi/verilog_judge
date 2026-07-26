module comparator_2bit(input [1:0] a, input [1:0] b, output gt, output eq, output lt);
  assign gt = a > b;
  assign eq = a == b;
  assign lt = a < b;
endmodule
