module bit_clear_32bit_6(input [31:0] a, output [31:0] y);
  assign y = a & ~(32'b1 << 6);
endmodule
