`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg en;
  reg [7:0] d;
  wire [7:0] q;

  buggy_register_debug dut(.clk(clk), .rst(rst), .en(en), .d(d), .q(q));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; en = 0; d = 8'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; en = 1; d = 8'd1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; en = 0; d = 8'd255; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; en = 1; d = 8'd170; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; en = 0; d = 8'd2; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; en = 1; d = 8'd3; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; en = 0; d = 8'd127; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; en = 1; d = 8'd170; #1; @(posedge clk); #1; $display("%b", q);
    $finish;
  end
endmodule
