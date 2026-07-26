`timescale 1ns/1ps
module tb;
  reg i0, i1, sel;
  wire y;

  mux_2to1 dut(.i0(i0), .i1(i1), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);

    i0 = 0; i1 = 0; sel = 0; #5; $display("%b %b %b %b", i0, i1, sel, y);
    i0 = 0; i1 = 0; sel = 1; #5; $display("%b %b %b %b", i0, i1, sel, y);
    i0 = 0; i1 = 1; sel = 0; #5; $display("%b %b %b %b", i0, i1, sel, y);
    i0 = 0; i1 = 1; sel = 1; #5; $display("%b %b %b %b", i0, i1, sel, y);
    i0 = 1; i1 = 0; sel = 0; #5; $display("%b %b %b %b", i0, i1, sel, y);
    i0 = 1; i1 = 0; sel = 1; #5; $display("%b %b %b %b", i0, i1, sel, y);
    i0 = 1; i1 = 1; sel = 0; #5; $display("%b %b %b %b", i0, i1, sel, y);
    i0 = 1; i1 = 1; sel = 1; #5; $display("%b %b %b %b", i0, i1, sel, y);
    $finish;
  end
endmodule
