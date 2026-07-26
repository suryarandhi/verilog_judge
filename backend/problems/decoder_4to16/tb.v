`timescale 1ns/1ps
module tb;
  reg [3:0] a;
  wire [15:0] y;

  decoder_4to16 dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'b0000; #5; $display("%b %b", a, y);
    a = 4'b0001; #5; $display("%b %b", a, y);
    a = 4'b0010; #5; $display("%b %b", a, y);
    a = 4'b0011; #5; $display("%b %b", a, y);
    a = 4'b0100; #5; $display("%b %b", a, y);
    a = 4'b0101; #5; $display("%b %b", a, y);
    a = 4'b0110; #5; $display("%b %b", a, y);
    a = 4'b0111; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
