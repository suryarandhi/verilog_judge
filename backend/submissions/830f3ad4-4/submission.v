module synchronous_clear_counter(input clk, input rst, input clear, output reg [3:0] count);
  always @(*) begin
      count = 4'b0;
    end
endmodule
