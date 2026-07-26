`timescale 1ns/1ps
module tb;
  reg clk, reset, d;
  wire q;

  d_flipflop dut(.clk(clk), .reset(reset), .d(d), .q(q));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1; d = 0; #7;  $display("%b %b %b", reset, d, q);
    reset = 0; d = 1; #10; $display("%b %b %b", reset, d, q);
    d = 0;          #10; $display("%b %b %b", reset, d, q);
    d = 1;          #10; $display("%b %b %b", reset, d, q);
    reset = 1;      #3;  $display("%b %b %b", reset, d, q);
    reset = 0; d = 0; #10; $display("%b %b %b", reset, d, q);
    $finish;
  end
endmodule
