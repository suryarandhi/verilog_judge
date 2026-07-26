module traffic_light_fsm(input clk, input rst, output reg red, output reg green, output reg yellow);
  always @(*) begin
      red = 1'b0;
      green = 1'b0;
      yellow = 1'b0;
    end
endmodule
