`timescale 1ns/1ps
module tb;
  reg [0:0] a, b;
  reg sel;
  wire [0:0] y;

  mux2_1bit dut(.a(a), .b(b), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 1'b0; b = 1'b1; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 1'b0; b = 1'b1; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 1'b1; b = 1'b0; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 1'b1; b = 1'b0; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    $finish;
  end
endmodule
