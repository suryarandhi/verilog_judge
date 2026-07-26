`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg [2:0] req;
  wire [2:0] grant;

  bus_arbiter dut(.clk(clk), .rst(rst), .req(req), .grant(grant));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; req = 3'd0; #1; @(posedge clk); #1; $display("%b", grant);
    rst = 0; req = 3'd1; #1; @(posedge clk); #1; $display("%b", grant);
    rst = 0; req = 3'd7; #1; @(posedge clk); #1; $display("%b", grant);
    rst = 0; req = 3'd2; #1; @(posedge clk); #1; $display("%b", grant);
    rst = 0; req = 3'd2; #1; @(posedge clk); #1; $display("%b", grant);
    rst = 0; req = 3'd3; #1; @(posedge clk); #1; $display("%b", grant);
    rst = 0; req = 3'd3; #1; @(posedge clk); #1; $display("%b", grant);
    rst = 0; req = 3'd2; #1; @(posedge clk); #1; $display("%b", grant);
    $finish;
  end
endmodule
