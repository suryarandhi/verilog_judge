module decoder_3to8(input [2:0] sel, output [7:0] y);
  assign y = 8'b00000001 << sel;
endmodule
