`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  wire [3:0] q;

  johnson_counter_4bit dut(.clk(clk), .rst(rst), .q(q));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; #1; @(posedge clk); #1; $display("%b", q);
    $finish;
  end
endmodule
