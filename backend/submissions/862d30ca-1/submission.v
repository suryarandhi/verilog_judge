module adder_3bit(input [2:0] a, input [2:0] b, output [2:0] sum, output cout);
  assign {cout, sum} = a + b;
endmodule
