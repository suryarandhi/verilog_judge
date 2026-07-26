module data_router(input [7:0] a, input [7:0] b, input [7:0] c, input [7:0] d, input [1:0] sel, output [7:0] y);
  assign y = (sel == 2'd0) ? a : (sel == 2'd1) ? b : (sel == 2'd2) ? c : d;
endmodule
