`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  wire red;
  wire green;
  wire yellow;

  traffic_light_fsm dut(.clk(clk), .rst(rst), .red(red), .green(green), .yellow(yellow));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    rst = 0; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    rst = 0; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    rst = 0; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    rst = 0; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    rst = 0; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    rst = 0; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    rst = 0; #1; @(posedge clk); #1; $display("%b %b %b", red, green, yellow);
    $finish;
  end
endmodule
