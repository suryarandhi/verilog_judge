module find_bug_clock_divider(input clk, input rst, input [3:0] n, output reg clk_out);
  reg [3:0] count;
  always @(posedge clk) begin
    if (rst) begin count <= 4'd0; clk_out <= 1'b0; end
    else if (count >= n) begin count <= 4'd0; clk_out <= ~clk_out; end
    else count <= count + 4'd1;
  end
endmodule
