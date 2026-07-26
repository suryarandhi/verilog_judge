module signed_magnitude_selector(input signed [7:0] a, input signed [7:0] b, input sel, output reg signed [7:0] y, output reg negative);
  always @(*) begin
      y = 8'b0;
      negative = 1'b0;
    end
endmodule
