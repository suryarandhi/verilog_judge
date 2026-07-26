module gray_counter_3bit(input clk, input reset, output reg [2:0] gray);
  reg [2:0] bin;
  always @(posedge clk) begin
    if (reset) begin bin <= 3'b000; gray <= 3'b000; end
    else begin bin <= bin + 3'd1; gray <= ((bin + 3'd1) >> 1) ^ (bin + 3'd1); end
  end
endmodule
