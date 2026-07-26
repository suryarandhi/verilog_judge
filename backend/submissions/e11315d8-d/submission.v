module saturating_counter(input clk, input rst, input en, output reg [3:0] count);
  always @(*) begin
      count = 4'b0;
    end
endmodule
