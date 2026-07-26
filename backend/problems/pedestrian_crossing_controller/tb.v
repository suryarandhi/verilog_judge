`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg walk_request;
  wire vehicle_green;
  wire vehicle_yellow;
  wire vehicle_red;
  wire walk;

  pedestrian_crossing_controller dut(.clk(clk), .rst(rst), .walk_request(walk_request), .vehicle_green(vehicle_green), .vehicle_yellow(vehicle_yellow), .vehicle_red(vehicle_red), .walk(walk));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; walk_request = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    rst = 0; walk_request = 1'd1; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    rst = 0; walk_request = 1'd1; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    rst = 0; walk_request = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    rst = 0; walk_request = 1'd2; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    rst = 0; walk_request = 1'd3; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    rst = 0; walk_request = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    rst = 0; walk_request = 1'd0; #1; @(posedge clk); #1; $display("%b %b %b %b", vehicle_green, vehicle_yellow, vehicle_red, walk);
    $finish;
  end
endmodule
