module identify_race_condition(input clk, input rst, input a, input b, output reg [1:0] q);
  always @(*) begin
      q = 2'b0;
    end
endmodule
