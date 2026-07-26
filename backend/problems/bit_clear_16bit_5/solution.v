module bit_clear_16bit_5(input [15:0] a, output [15:0] y);
  assign y = a & ~(16'b1 << 5);
endmodule
