module rising_edge_detector(input clk, input rst, input signal, output reg pulse);
  always @(*) begin
      pulse = 1'b0;
    end
endmodule
