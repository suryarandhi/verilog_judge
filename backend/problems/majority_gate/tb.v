`timescale 1ns/1ps
module tb;
  reg a;
  reg b;
  reg c;
  wire y;

  majority_gate dut(.a(a), .b(b), .c(c), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 1'd0; b = 1'd0; c = 1'd0; #1; $display("%b", y);
    a = 1'd1; b = 1'd1; c = 1'd1; #1; $display("%b", y);
    a = 1'd1; b = 1'd1; c = 1'd1; #1; $display("%b", y);
    a = 1'd0; b = 1'd0; c = 1'd0; #1; $display("%b", y);
    a = 1'd2; b = 1'd2; c = 1'd2; #1; $display("%b", y);
    a = 1'd3; b = 1'd3; c = 1'd3; #1; $display("%b", y);
    a = 1'd0; b = 1'd0; c = 1'd0; #1; $display("%b", y);
    a = 1'd0; b = 1'd0; c = 1'd0; #1; $display("%b", y);
    $finish;
  end
endmodule
