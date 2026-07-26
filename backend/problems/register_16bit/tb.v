`timescale 1ns/1ps
module tb;
  reg clk, reset, load;
  reg [15:0] d;
  wire [15:0] q;
  register_16bit dut(.clk(clk), .reset(reset), .load(load), .d(d), .q(q));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1; load = 0; d = 16'b0; #7; $display("%b %b %b %b", reset, load, d, q);
    reset = 0; load = 1; d = 16'b1111111111111111; #10; $display("%b %b %b %b", reset, load, d, q);
    load = 0; d = 16'b1000000000000000; #10; $display("%b %b %b %b", reset, load, d, q);
    load = 1; d = 16'b1000000000000000; #10; $display("%b %b %b %b", reset, load, d, q);
    reset = 1; #3; $display("%b %b %b %b", reset, load, d, q);
    $finish;
  end
endmodule
