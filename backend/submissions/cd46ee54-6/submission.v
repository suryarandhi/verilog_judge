module bitwise_nand(input [7:0] a, input [7:0] b, output [7:0] y);
  // Write your code here
  y = ~(a && b) ;
endmodule