`timescale 1ns/1ps
module tb;
  reg clk, reset, d;
  wire q;
  fixed_dff dut(.clk(clk), .reset(reset), .d(d), .q(q));
  initial begin clk = 0; forever #5 clk = ~clk; end
  initial begin
    $dumpfile("simulation.vcd"); $dumpvars(0, tb);
    reset = 1; d = 1; #3; $display("%b %b %b", reset, d, q);
    reset = 0; d = 1; #12; $display("%b %b %b", reset, d, q);
    d = 0; #10; $display("%b %b %b", reset, d, q);
    reset = 1; #2; $display("%b %b %b", reset, d, q);
    $finish;
  end
endmodule
