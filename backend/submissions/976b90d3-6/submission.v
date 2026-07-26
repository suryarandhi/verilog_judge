module bit_set_32bit_5(input [31:0] a, output [31:0] y);
  assign y = a | (32'b1 << 5);
endmodule
