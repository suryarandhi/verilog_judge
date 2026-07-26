module thermal_shutdown_fsm(input clk, input rst, input [7:0] temp, output reg fan_enable);
  always @(*) begin
      fan_enable = 1'b0;
    end
endmodule
