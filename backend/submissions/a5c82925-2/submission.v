module decoder_2to4(input [1:0] a, output [3:0] y);
  assign y = 4'b0001 << a;
endmodule
