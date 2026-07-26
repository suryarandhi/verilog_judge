`timescale 1ns/1ps
module tb;
  reg [15:0] a, b;
  wire [15:0] y;

  or_16bit dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 16'b0000000000000000; b = 16'b0000000000000000; #5; $display("%b %b %b", a, b, y);
    a = 16'b0000000000000000; b = 16'b1111111111111111; #5; $display("%b %b %b", a, b, y);
    a = 16'b1111111111111111; b = 16'b0000000000000000; #5; $display("%b %b %b", a, b, y);
    a = 16'b1111111111111111; b = 16'b1111111111111111; #5; $display("%b %b %b", a, b, y);
    a = 16'b1000000000000000; b = 16'b1111111111111111; #5; $display("%b %b %b", a, b, y);
    a = 16'b0101010101010101; b = 16'b1010101010101010; #5; $display("%b %b %b", a, b, y);
    $finish;
  end
endmodule
