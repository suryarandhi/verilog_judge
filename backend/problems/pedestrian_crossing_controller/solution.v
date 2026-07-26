module pedestrian_crossing_controller(input clk, input rst, input walk_request, output reg vehicle_green, output reg vehicle_yellow, output reg vehicle_red, output reg walk);
  reg [1:0] state;
  always @(posedge clk) begin
    if (rst) state <= 2'd0;
    else case (state)
      2'd0: state <= walk_request ? 2'd1 : 2'd0;
      2'd1: state <= 2'd2;
      2'd2: state <= 2'd3;
      default: state <= 2'd0;
    endcase
  end
  always @(*) begin
    vehicle_green = state == 2'd0;
    vehicle_yellow = state == 2'd1;
    vehicle_red = state == 2'd2 || state == 2'd3;
    walk = state == 2'd3;
  end
endmodule
