`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg dir;
  wire [3:0] count;

  up_down_counter dut(.clk(clk), .rst(rst), .dir(dir), .count(count));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; dir = 0; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; dir = 1; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; dir = 0; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; dir = 1; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; dir = 0; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; dir = 1; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; dir = 0; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; dir = 1; #1; @(posedge clk); #1; $display("%b", count);
    $finish;
  end
endmodule
