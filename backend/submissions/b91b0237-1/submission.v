module multiplier_accumulator(input clk, input rst, input en, input [3:0] a, input [3:0] b, output reg [7:0] acc);
  always @(*) begin
      acc = 8'b0;
    end
endmodule
