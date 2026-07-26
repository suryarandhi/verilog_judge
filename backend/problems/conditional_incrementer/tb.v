`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg enable;
  wire [7:0] y;

  conditional_incrementer dut(.a(a), .enable(enable), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; enable = 1'd0; #1; $display("%b", y);
    a = 8'd1; enable = 1'd1; #1; $display("%b", y);
    a = 8'd255; enable = 1'd1; #1; $display("%b", y);
    a = 8'd170; enable = 1'd0; #1; $display("%b", y);
    a = 8'd2; enable = 1'd2; #1; $display("%b", y);
    a = 8'd3; enable = 1'd3; #1; $display("%b", y);
    a = 8'd127; enable = 1'd0; #1; $display("%b", y);
    a = 8'd170; enable = 1'd0; #1; $display("%b", y);
    $finish;
  end
endmodule
