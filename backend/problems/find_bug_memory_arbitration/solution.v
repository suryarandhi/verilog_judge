module find_bug_memory_arbitration(input clk, input rst, input [2:0] req, output reg [2:0] grant);
  always @(posedge clk) begin
    if (rst) grant <= 3'b000;
    else if (req[2]) grant <= 3'b100;
    else if (req[1]) grant <= 3'b010;
    else if (req[0]) grant <= 3'b001;
    else grant <= 3'b000;
  end
endmodule
