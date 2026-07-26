`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  wire above_threshold;

  threshold_detector dut(.a(a), .above_threshold(above_threshold));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; #1; $display("%b", above_threshold);
    a = 8'd1; #1; $display("%b", above_threshold);
    a = 8'd255; #1; $display("%b", above_threshold);
    a = 8'd170; #1; $display("%b", above_threshold);
    a = 8'd2; #1; $display("%b", above_threshold);
    a = 8'd3; #1; $display("%b", above_threshold);
    a = 8'd127; #1; $display("%b", above_threshold);
    a = 8'd170; #1; $display("%b", above_threshold);
    $finish;
  end
endmodule
