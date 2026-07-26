module adder_2bit(input [1:0] a, input [1:0] b, output [1:0] sum, output cout);
  assign {cout, sum} = a + b;
endmodule
