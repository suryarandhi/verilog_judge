module elevator_floor_controller(input clk, input rst, input request_up, input request_down, output reg [1:0] floor, output reg moving_up, output reg moving_down);
  always @(*) begin
      floor = 2'b0;
      moving_up = 1'b0;
      moving_down = 1'b0;
    end
endmodule
