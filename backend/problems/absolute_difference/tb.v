`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg [7:0] b;
  wire [7:0] diff;

  absolute_difference dut(.a(a), .b(b), .diff(diff));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; #1; $display("%b", diff);
    a = 8'd1; b = 8'd1; #1; $display("%b", diff);
    a = 8'd255; b = 8'd255; #1; $display("%b", diff);
    a = 8'd170; b = 8'd170; #1; $display("%b", diff);
    a = 8'd2; b = 8'd2; #1; $display("%b", diff);
    a = 8'd3; b = 8'd3; #1; $display("%b", diff);
    a = 8'd127; b = 8'd127; #1; $display("%b", diff);
    a = 8'd170; b = 8'd170; #1; $display("%b", diff);
    $finish;
  end
endmodule
