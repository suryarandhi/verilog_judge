module conditional_incrementer(input [7:0] a, input enable, output [7:0] y);
  assign y = enable ? a + 8'd1 : a;
endmodule
