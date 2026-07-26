module min_max_selector(input signed [7:0] a, input signed [7:0] b, input sel, output signed [7:0] y);
  assign y = sel ? ((a > b) ? a : b) : ((a < b) ? a : b);
endmodule
