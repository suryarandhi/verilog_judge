module bit_toggle_32bit_0(input [31:0] a, output [31:0] y);
  assign y = a ^ (32'b1 << 0);
endmodule
