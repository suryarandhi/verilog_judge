module find_bug_dff_reset_polarity(input clk, input rst, input d, output reg q);
  always @(*) begin
      q = 1'b0;
    end
endmodule
