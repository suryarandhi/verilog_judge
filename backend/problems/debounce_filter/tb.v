`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg noisy;
  wire clean;

  debounce_filter dut(.clk(clk), .rst(rst), .noisy(noisy), .clean(clean));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; noisy = 1'd0; #1; @(posedge clk); #1; $display("%b", clean);
    rst = 0; noisy = 1'd1; #1; @(posedge clk); #1; $display("%b", clean);
    rst = 0; noisy = 1'd1; #1; @(posedge clk); #1; $display("%b", clean);
    rst = 0; noisy = 1'd0; #1; @(posedge clk); #1; $display("%b", clean);
    rst = 0; noisy = 1'd2; #1; @(posedge clk); #1; $display("%b", clean);
    rst = 0; noisy = 1'd3; #1; @(posedge clk); #1; $display("%b", clean);
    rst = 0; noisy = 1'd0; #1; @(posedge clk); #1; $display("%b", clean);
    rst = 0; noisy = 1'd0; #1; @(posedge clk); #1; $display("%b", clean);
    $finish;
  end
endmodule
