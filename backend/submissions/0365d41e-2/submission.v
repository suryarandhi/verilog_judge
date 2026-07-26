module bit_set_8bit_4(input [7:0] a, output [7:0] y);
  assign y = a | (8'b1 << 4);
endmodule
