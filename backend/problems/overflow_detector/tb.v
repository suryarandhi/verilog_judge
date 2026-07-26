`timescale 1ns/1ps
module tb;
  reg signed [7:0] a;
  reg signed [7:0] b;
  reg signed [7:0] sum;
  wire overflow;

  overflow_detector dut(.a(a), .b(b), .sum(sum), .overflow(overflow));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; sum = 8'd0; #1; $display("%b", overflow);
    a = 8'd1; b = 8'd1; sum = 8'd1; #1; $display("%b", overflow);
    a = 8'd255; b = 8'd255; sum = 8'd255; #1; $display("%b", overflow);
    a = 8'd170; b = 8'd170; sum = 8'd170; #1; $display("%b", overflow);
    a = 8'd2; b = 8'd2; sum = 8'd2; #1; $display("%b", overflow);
    a = 8'd3; b = 8'd3; sum = 8'd3; #1; $display("%b", overflow);
    a = 8'd127; b = 8'd127; sum = 8'd127; #1; $display("%b", overflow);
    a = 8'd170; b = 8'd170; sum = 8'd170; #1; $display("%b", overflow);
    $finish;
  end
endmodule
