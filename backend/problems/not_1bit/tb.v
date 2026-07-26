`timescale 1ns/1ps
module tb;
  reg [0:0] a;
  wire [0:0] y;

  not_1bit dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 1'b0; #5; $display("%b %b", a, y);
    a = 1'b1; #5; $display("%b %b", a, y);
    a = 1'b1; #5; $display("%b %b", a, y);
    a = 1'b1; #5; $display("%b %b", a, y);
    a = 1'b1; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
