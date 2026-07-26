module gray_counter_3bit(input clk, input reset, output reg [2:0] gray);
  always @(*) begin
      gray = 3'b0;
    end
endmodule
