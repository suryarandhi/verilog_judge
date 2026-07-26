module traffic_light_fsm(input clk, input reset, input timer_done, output reg red, output reg yellow, output reg green);
  reg [1:0] state;
  localparam RED = 2'd0, GREEN = 2'd1, YELLOW = 2'd2;
  always @(posedge clk or posedge reset) begin
    if (reset) state <= RED;
    else if (timer_done) begin
      case (state)
        RED: state <= GREEN;
        GREEN: state <= YELLOW;
        default: state <= RED;
      endcase
    end
  end
  always @(*) begin
    red = state == RED;
    green = state == GREEN;
    yellow = state == YELLOW;
  end
endmodule
