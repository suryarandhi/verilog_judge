module bit_toggle_16bit_6(input [15:0] a, output [15:0] y);
  assign y = a ^ (16'b1 << 6);
endmodule
