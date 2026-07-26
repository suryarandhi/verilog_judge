module mux_2to1(input [7:0] a, input [7:0] b, input sel, output [7:0] y);
  // Write your code here
  assign y = sel ? a:b;

endmodule