module pedestrian_crossing_controller(input clk, input rst, input walk_request, output reg vehicle_green, output reg vehicle_yellow, output reg vehicle_red, output reg walk);
  always @(*) begin
      vehicle_green = 1'b0;
      vehicle_yellow = 1'b0;
      vehicle_red = 1'b0;
      walk = 1'b0;
    end
endmodule
