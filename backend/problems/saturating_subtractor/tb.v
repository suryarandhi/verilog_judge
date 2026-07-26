`timescale 1ns/1ps
module tb;
  reg signed [7:0] a;
  reg signed [7:0] b;
  wire signed [7:0] y;

  saturating_subtractor dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; #1; $display("%b", y);
    a = 8'd1; b = 8'd1; #1; $display("%b", y);
    a = 8'd255; b = 8'd255; #1; $display("%b", y);
    a = 8'd170; b = 8'd170; #1; $display("%b", y);
    a = 8'd2; b = 8'd2; #1; $display("%b", y);
    a = 8'd3; b = 8'd3; #1; $display("%b", y);
    a = 8'd127; b = 8'd127; #1; $display("%b", y);
    a = 8'd170; b = 8'd170; #1; $display("%b", y);
    $finish;
  end
endmodule
