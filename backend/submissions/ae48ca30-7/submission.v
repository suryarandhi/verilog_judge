module find_bug_clock_divider(input clk, input rst, input [3:0] n, output reg clk_out);
  always @(*) begin
      clk_out = 1'b0;
    end
endmodule
