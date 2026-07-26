`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg [7:0] b;
  wire gt;
  wire eq;
  wire lt;

  comparator_unsigned dut(.a(a), .b(b), .gt(gt), .eq(eq), .lt(lt));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; #1; $display("%b %b %b", gt, eq, lt);
    a = 8'd1; b = 8'd1; #1; $display("%b %b %b", gt, eq, lt);
    a = 8'd255; b = 8'd255; #1; $display("%b %b %b", gt, eq, lt);
    a = 8'd170; b = 8'd170; #1; $display("%b %b %b", gt, eq, lt);
    a = 8'd2; b = 8'd2; #1; $display("%b %b %b", gt, eq, lt);
    a = 8'd3; b = 8'd3; #1; $display("%b %b %b", gt, eq, lt);
    a = 8'd127; b = 8'd127; #1; $display("%b %b %b", gt, eq, lt);
    a = 8'd170; b = 8'd170; #1; $display("%b %b %b", gt, eq, lt);
    $finish;
  end
endmodule
