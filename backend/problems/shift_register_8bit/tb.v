`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg serial_in;
  wire [7:0] q;

  shift_register_8bit dut(.clk(clk), .rst(rst), .serial_in(serial_in), .q(q));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd1; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd2; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd3; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    rst = 0; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", q);
    $finish;
  end
endmodule
