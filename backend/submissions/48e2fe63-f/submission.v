module decoder_3to8(input [2:0] a, output [7:0] y);
  assign y = 8'b1 << a;
endmodule
