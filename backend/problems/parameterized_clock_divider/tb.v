`timescale 1ns/1ps
module tb;
  reg clk;
  reg reset;
  wire clk_out;

  clock_divider dut(.clk(clk), .reset(reset), .clk_out(clk_out));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    reset = 1; #1; @(posedge clk); #1; $display("%b", clk_out);
    reset = 0; #1; @(posedge clk); #1; $display("%b", clk_out);
    reset = 0; #1; @(posedge clk); #1; $display("%b", clk_out);
    reset = 0; #1; @(posedge clk); #1; $display("%b", clk_out);
    reset = 0; #1; @(posedge clk); #1; $display("%b", clk_out);
    reset = 0; #1; @(posedge clk); #1; $display("%b", clk_out);
    reset = 0; #1; @(posedge clk); #1; $display("%b", clk_out);
    reset = 0; #1; @(posedge clk); #1; $display("%b", clk_out);
    $finish;
  end
endmodule
