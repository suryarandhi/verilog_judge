module thermal_shutdown_fsm(input clk, input rst, input [7:0] temp, output reg fan_enable);
  always @(posedge clk) begin
    if (rst) fan_enable <= 1'b0;
    else if (temp >= 8'd100) fan_enable <= 1'b0;
    else if (temp < 8'd90) fan_enable <= 1'b1;
  end
endmodule
