module clock_divider #(parameter N = 4)(input clk, input reset, output reg clk_out);
  always @(*) begin
      clk_out = 1'b0;
    end
endmodule
