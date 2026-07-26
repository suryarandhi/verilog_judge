module bit_set_4bit_1(input [3:0] a, output [3:0] y);
  assign y = a | (4'b1 << 1);
endmodule
