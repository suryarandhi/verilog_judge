module bit_set_32bit_7(input [31:0] a, output [31:0] y);
  assign y = a | (32'b1 << 7);
endmodule
