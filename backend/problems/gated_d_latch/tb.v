`timescale 1ns/1ps
module tb;
  reg en;
  reg d;
  wire q;

  gated_d_latch dut(.en(en), .d(d), .q(q));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    en = 0; d = 1'd0; #1; $display("%b", q);
    en = 1; d = 1'd1; #1; $display("%b", q);
    en = 0; d = 1'd1; #1; $display("%b", q);
    en = 1; d = 1'd0; #1; $display("%b", q);
    en = 0; d = 1'd2; #1; $display("%b", q);
    en = 1; d = 1'd3; #1; $display("%b", q);
    en = 0; d = 1'd0; #1; $display("%b", q);
    en = 1; d = 1'd0; #1; $display("%b", q);
    $finish;
  end
endmodule
