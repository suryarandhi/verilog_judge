module memory_arbiter_3to1(input clk, input rst, input [2:0] req, output reg [2:0] grant);
  always @(*) begin
      grant = 3'b0;
    end
endmodule
