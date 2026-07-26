`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg a;
  reg b;
  wire [1:0] q;

  identify_race_condition dut(.clk(clk), .rst(rst), .a(a), .b(b), .q(q));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; a = 1'd0; b = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; a = 1'd1; b = 1'd1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; a = 1'd1; b = 1'd1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; a = 1'd0; b = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; a = 1'd2; b = 1'd2; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; a = 1'd3; b = 1'd3; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; a = 1'd0; b = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; a = 1'd0; b = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    $finish;
  end
endmodule
