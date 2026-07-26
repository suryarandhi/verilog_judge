`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg serial_in;
  reg load;
  wire [7:0] q;

  serial_to_parallel_register dut(.clk(clk), .rst(rst), .serial_in(serial_in), .load(load), .q(q));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; serial_in = 1'd0; load = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd1; load = 1'd1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd1; load = 1'd1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd0; load = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd2; load = 1'd2; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd3; load = 1'd3; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd0; load = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd0; load = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    $finish;
  end
endmodule
