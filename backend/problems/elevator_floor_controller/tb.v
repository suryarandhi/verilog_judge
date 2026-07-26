`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg request_up;
  reg request_down;
  wire [1:0] floor;
  wire moving_up;
  wire moving_down;

  elevator_floor_controller dut(.clk(clk), .rst(rst), .request_up(request_up), .request_down(request_down), .floor(floor), .moving_up(moving_up), .moving_down(moving_down));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; request_up = 1'd0; request_down = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    rst = 0; request_up = 1'd1; request_down = 1'd1; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    rst = 0; request_up = 1'd1; request_down = 1'd1; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    rst = 0; request_up = 1'd0; request_down = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    rst = 0; request_up = 1'd2; request_down = 1'd2; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    rst = 0; request_up = 1'd3; request_down = 1'd3; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    rst = 0; request_up = 1'd0; request_down = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    rst = 0; request_up = 1'd0; request_down = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b", floor, moving_up, moving_down);
    $finish;
  end
endmodule
