module traffic_light_fsm(input clk, input rst, output reg red, output reg green, output reg yellow);
  reg [1:0] state;
  always @(posedge clk) begin
    if (rst) state <= 2'd0;
    else if (state == 2'd2) state <= 2'd0;
    else state <= state + 2'd1;
  end
  always @(*) begin
    red = state == 2'd0;
    green = state == 2'd1;
    yellow = state == 2'd2;
  end
endmodule
