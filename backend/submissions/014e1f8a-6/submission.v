module up_down_counter(input clk, input rst, input dir, output reg [3:0] count);
  always @(*) begin
      count = 4'b0;
    end
endmodule
