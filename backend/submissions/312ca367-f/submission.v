module bit_toggle_4bit_2(input [3:0] a, output [3:0] y);
  assign y = a ^ (4'b1 << 2);
endmodule
