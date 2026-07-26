module bit_clear_8bit_7(input [7:0] a, output [7:0] y);
  assign y = a & ~(8'b1 << 7);
endmodule
