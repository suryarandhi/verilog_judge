`timescale 1ns/1ps
module tb;
  reg a, b;
  wire y;
  xor_gate dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 0; b = 0; #5; $display("%b %b %b", a, b, y);
    a = 0; b = 1; #5; $display("%b %b %b", a, b, y);
    a = 1; b = 0; #5; $display("%b %b %b", a, b, y);
    a = 1; b = 1; #5; $display("%b %b %b", a, b, y);
    $finish;
  end
endmodule
