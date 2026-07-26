module bit_clear_32bit_3(input [31:0] a, output [31:0] y);
  assign y = a & ~(32'b1 << 3);
endmodule
