`timescale 1ns/1ps
module tb;
  reg [15:0] a;
  wire [15:0] y;

  bit_toggle_16bit_5 dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 16'b0000000000000000; #5; $display("%b %b", a, y);
    a = 16'b0000000000100000; #5; $display("%b %b", a, y);
    a = 16'b1111111111111111; #5; $display("%b %b", a, y);
    a = 16'b1010101010101010; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
