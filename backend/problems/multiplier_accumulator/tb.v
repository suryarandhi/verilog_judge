`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg en;
  reg [3:0] a;
  reg [3:0] b;
  wire [7:0] acc;

  multiplier_accumulator dut(.clk(clk), .rst(rst), .en(en), .a(a), .b(b), .acc(acc));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; en = 0; a = 4'd0; b = 4'd0; #1; @(posedge clk); #1; $display("%b", acc);
    rst = 0; en = 1; a = 4'd1; b = 4'd1; #1; @(posedge clk); #1; $display("%b", acc);
    rst = 0; en = 0; a = 4'd15; b = 4'd15; #1; @(posedge clk); #1; $display("%b", acc);
    rst = 0; en = 1; a = 4'd10; b = 4'd10; #1; @(posedge clk); #1; $display("%b", acc);
    rst = 0; en = 0; a = 4'd2; b = 4'd2; #1; @(posedge clk); #1; $display("%b", acc);
    rst = 0; en = 1; a = 4'd3; b = 4'd3; #1; @(posedge clk); #1; $display("%b", acc);
    rst = 0; en = 0; a = 4'd7; b = 4'd7; #1; @(posedge clk); #1; $display("%b", acc);
    rst = 0; en = 1; a = 4'd10; b = 4'd10; #1; @(posedge clk); #1; $display("%b", acc);
    $finish;
  end
endmodule
