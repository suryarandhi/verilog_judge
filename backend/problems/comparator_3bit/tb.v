`timescale 1ns/1ps
module tb;
  reg [2:0] a, b;
  wire gt, eq, lt;

  comparator_3bit dut(.a(a), .b(b), .gt(gt), .eq(eq), .lt(lt));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 3'b000; b = 3'b000; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 3'b001; b = 3'b001; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 3'b111; b = 3'b001; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 3'b011; b = 3'b010; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 3'b111; b = 3'b111; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    $finish;
  end
endmodule
