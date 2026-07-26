module clock_divider #(parameter N = 4)(input clk, input reset, output reg clk_out);
  reg [31:0] count;
  always @(posedge clk) begin
    if (reset) begin count <= 0; clk_out <= 1'b0; end
    else if (count == N - 1) begin count <= 0; clk_out <= ~clk_out; end
    else count <= count + 1;
  end
endmodule
