module counter_up_2bit(input clk, input reset, input enable, output reg [1:0] count);
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      count <= 2'b0;
    end else if (enable) begin
      count <= count + 2'b1;
    end
  end
endmodule
