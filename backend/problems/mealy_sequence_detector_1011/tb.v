`timescale 1ns/1ps
module tb;
  reg clk;
  reg reset;
  reg din;
  wire detected;

  mealy_1011_detector dut(.clk(clk), .reset(reset), .din(din), .detected(detected));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    reset = 1; din = 1'd0; #1; @(posedge clk); #1; $display("%b", detected);
    reset = 0; din = 1'd1; #1; @(posedge clk); #1; $display("%b", detected);
    reset = 0; din = 1'd1; #1; @(posedge clk); #1; $display("%b", detected);
    reset = 0; din = 1'd0; #1; @(posedge clk); #1; $display("%b", detected);
    reset = 0; din = 1'd2; #1; @(posedge clk); #1; $display("%b", detected);
    reset = 0; din = 1'd3; #1; @(posedge clk); #1; $display("%b", detected);
    reset = 0; din = 1'd0; #1; @(posedge clk); #1; $display("%b", detected);
    reset = 0; din = 1'd0; #1; @(posedge clk); #1; $display("%b", detected);
    $finish;
  end
endmodule
