module bit_toggle_8bit_2(input [7:0] a, output [7:0] y);
  assign y = a ^ (8'b1 << 2);
endmodule
