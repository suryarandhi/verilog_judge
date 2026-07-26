module rising_edge_detector(input clk, input rst, input signal, output reg pulse);
  reg prev;
  always @(posedge clk) begin
    if (rst) begin prev <= 1'b0; pulse <= 1'b0; end
    else begin pulse <= signal & ~prev; prev <= signal; end
  end
endmodule
