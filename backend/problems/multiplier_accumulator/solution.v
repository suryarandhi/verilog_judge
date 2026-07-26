module multiplier_accumulator(input clk, input rst, input en, input [3:0] a, input [3:0] b, output reg [7:0] acc);
  always @(posedge clk) begin
    if (rst) acc <= 8'b0;
    else if (en) acc <= acc + (a * b);
  end
endmodule
