`timescale 1ns/1ps
module tb;
  reg [1:0] a, b;
  wire gt, eq, lt;

  comparator_2bit dut(.a(a), .b(b), .gt(gt), .eq(eq), .lt(lt));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 2'b00; b = 2'b00; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 2'b01; b = 2'b01; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 2'b11; b = 2'b01; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 2'b01; b = 2'b01; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    a = 2'b11; b = 2'b11; #5; $display("%b %b %b %b %b", a, b, gt, eq, lt);
    $finish;
  end
endmodule
