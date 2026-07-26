`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg [3:0] n;
  wire clk_out;

  find_bug_clock_divider dut(.clk(clk), .rst(rst), .n(n), .clk_out(clk_out));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; n = 4'd0; #1; @(posedge clk); #1; $display("%b", clk_out);
    rst = 0; n = 4'd1; #1; @(posedge clk); #1; $display("%b", clk_out);
    rst = 0; n = 4'd15; #1; @(posedge clk); #1; $display("%b", clk_out);
    rst = 0; n = 4'd10; #1; @(posedge clk); #1; $display("%b", clk_out);
    rst = 0; n = 4'd2; #1; @(posedge clk); #1; $display("%b", clk_out);
    rst = 0; n = 4'd3; #1; @(posedge clk); #1; $display("%b", clk_out);
    rst = 0; n = 4'd7; #1; @(posedge clk); #1; $display("%b", clk_out);
    rst = 0; n = 4'd10; #1; @(posedge clk); #1; $display("%b", clk_out);
    $finish;
  end
endmodule
