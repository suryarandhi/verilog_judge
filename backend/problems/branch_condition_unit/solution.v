module branch_condition_unit(input signed [7:0] value, input branch_neg, output taken);
  assign taken = branch_neg && (value <= 0);
endmodule
