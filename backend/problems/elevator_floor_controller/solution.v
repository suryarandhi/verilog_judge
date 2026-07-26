module elevator_floor_controller(input clk, input rst, input request_up, input request_down, output reg [1:0] floor, output reg moving_up, output reg moving_down);
  always @(posedge clk) begin
    if (rst) begin floor <= 2'd1; moving_up <= 1'b0; moving_down <= 1'b0; end
    else if (request_up && floor < 2'd3) begin floor <= floor + 2'd1; moving_up <= 1'b1; moving_down <= 1'b0; end
    else if (request_down && floor > 2'd1) begin floor <= floor - 2'd1; moving_up <= 1'b0; moving_down <= 1'b1; end
    else begin moving_up <= 1'b0; moving_down <= 1'b0; end
  end
endmodule
