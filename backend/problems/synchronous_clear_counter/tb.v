`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg clear;
  wire [3:0] count;

  synchronous_clear_counter dut(.clk(clk), .rst(rst), .clear(clear), .count(count));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; clear = 1'd0; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; clear = 1'd1; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; clear = 1'd1; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; clear = 1'd0; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; clear = 1'd2; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; clear = 1'd3; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; clear = 1'd0; #1; @(posedge clk); #1; $display("%b", count);
    rst = 0; clear = 1'd0; #1; @(posedge clk); #1; $display("%b", count);
    $finish;
  end
endmodule
