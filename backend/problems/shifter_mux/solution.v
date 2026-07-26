module shifter_mux(input [7:0] a, input [7:0] b, input [1:0] sel, output [7:0] y);
  assign y = (sel == 2'd0) ? a : (sel == 2'd1) ? (a << 1) : (sel == 2'd2) ? (a >> 1) : ~a;
endmodule
