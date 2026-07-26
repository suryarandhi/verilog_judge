`timescale 1ns/1ps
module tb;
  reg [3:0] a;
  wire [3:0] y;

  bit_clear_4bit_0 dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'b0000; #5; $display("%b %b", a, y);
    a = 4'b0001; #5; $display("%b %b", a, y);
    a = 4'b1111; #5; $display("%b %b", a, y);
    a = 4'b1010; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
