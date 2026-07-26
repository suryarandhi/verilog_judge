`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg [7:0] temp;
  wire fan_enable;

  thermal_shutdown_fsm dut(.clk(clk), .rst(rst), .temp(temp), .fan_enable(fan_enable));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; temp = 8'd0; #1; @(posedge clk); #1; $display("%b", fan_enable);
    rst = 0; temp = 8'd1; #1; @(posedge clk); #1; $display("%b", fan_enable);
    rst = 0; temp = 8'd255; #1; @(posedge clk); #1; $display("%b", fan_enable);
    rst = 0; temp = 8'd170; #1; @(posedge clk); #1; $display("%b", fan_enable);
    rst = 0; temp = 8'd2; #1; @(posedge clk); #1; $display("%b", fan_enable);
    rst = 0; temp = 8'd3; #1; @(posedge clk); #1; $display("%b", fan_enable);
    rst = 0; temp = 8'd127; #1; @(posedge clk); #1; $display("%b", fan_enable);
    rst = 0; temp = 8'd170; #1; @(posedge clk); #1; $display("%b", fan_enable);
    $finish;
  end
endmodule
