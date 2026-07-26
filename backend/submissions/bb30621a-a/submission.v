module mux2_1bit(input [0:0] a, input [0:0] b, input sel, output [0:0] y);
  assign y = sel ? b : a;
endmodule
