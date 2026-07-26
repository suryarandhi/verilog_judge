module decoder_4to16(input [3:0] a, output [15:0] y);
  assign y = 16'b1 << a;
endmodule
