`timescale 1ns/1ps
module tb;
  reg clk, reset, enable;
  wire [15:0] count;
  counter_up_16bit dut(.clk(clk), .reset(reset), .enable(enable), .count(count));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1; enable = 0; #7; $display("%b %b %b", reset, enable, count);
    reset = 0; enable = 1; #10; $display("%b %b %b", reset, enable, count);
    #10; $display("%b %b %b", reset, enable, count);
    enable = 0; #10; $display("%b %b %b", reset, enable, count);
    enable = 1; #10; $display("%b %b %b", reset, enable, count);
    reset = 1; #3; $display("%b %b %b", reset, enable, count);
    $finish;
  end
endmodule
