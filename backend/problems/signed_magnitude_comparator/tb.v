`timescale 1ns/1ps
module tb;
  reg [7:0] a, b;
  wire gt, eq, lt;
  signed_mag_compare dut(.a(a), .b(b), .gt(gt), .eq(eq), .lt(lt));
  initial begin
    $dumpfile("simulation.vcd"); $dumpvars(0, tb);
    a = 8'b00000101; b = 8'b10000011; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 8'b10000101; b = 8'b10000011; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 8'b00000100; b = 8'b00000100; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 8'b10000001; b = 8'b00000001; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    $finish;
  end
endmodule
