`timescale 1ns/1ps
module tb;
  reg [0:0] a, b;
  wire [0:0] y;

  xnor_1bit dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 1'b0; b = 1'b0; #5; $display("%b %b %b", a, b, y);
    a = 1'b0; b = 1'b1; #5; $display("%b %b %b", a, b, y);
    a = 1'b1; b = 1'b0; #5; $display("%b %b %b", a, b, y);
    a = 1'b1; b = 1'b1; #5; $display("%b %b %b", a, b, y);
    a = 1'b1; b = 1'b1; #5; $display("%b %b %b", a, b, y);
    a = 1'b0; b = 1'b1; #5; $display("%b %b %b", a, b, y);
    $finish;
  end
endmodule
