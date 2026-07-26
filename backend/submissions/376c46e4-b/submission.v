module saturating_accumulator(input clk, input rst, input en, input signed [7:0] d, output reg signed [7:0] q);
  always @(*) begin
      q = 8'b0;
    end
endmodule
