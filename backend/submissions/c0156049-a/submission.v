module rising_edge_detector(input clk, input reset, input signal_in, output reg pulse);
  reg previous;
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      previous <= 1'b0;
      pulse <= 1'b0;
    end else begin
      pulse <= signal_in & ~previous;
      previous <= signal_in;
    end
  end
endmodule
