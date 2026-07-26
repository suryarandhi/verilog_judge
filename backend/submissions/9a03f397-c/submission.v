module counter_up_8bit(input clk, input reset, input enable, output reg [7:0] count);
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 8'b0;
    end else if (enable) begin
      count <= count + 8'b1;
    end
  end
endmodule
