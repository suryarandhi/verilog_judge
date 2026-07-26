module bit_set_16bit_4(input [15:0] a, output [15:0] y);
  assign y = a | (16'b1 << 4);
endmodule
