module bit_set_8bit_3(input [7:0] a, output [7:0] y);
  assign y = a | (8'b1 << 3);
endmodule
