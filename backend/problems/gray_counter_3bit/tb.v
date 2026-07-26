`timescale 1ns/1ps
module tb;
  reg clk;
  reg reset;
  wire [2:0] gray;

  gray_counter_3bit dut(.clk(clk), .reset(reset), .gray(gray));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    reset = 1; #1; @(posedge clk); #1; $display("%b", gray);
    reset = 0; #1; @(posedge clk); #1; $display("%b", gray);
    reset = 0; #1; @(posedge clk); #1; $display("%b", gray);
    reset = 0; #1; @(posedge clk); #1; $display("%b", gray);
    reset = 0; #1; @(posedge clk); #1; $display("%b", gray);
    reset = 0; #1; @(posedge clk); #1; $display("%b", gray);
    reset = 0; #1; @(posedge clk); #1; $display("%b", gray);
    reset = 0; #1; @(posedge clk); #1; $display("%b", gray);
    $finish;
  end
endmodule
