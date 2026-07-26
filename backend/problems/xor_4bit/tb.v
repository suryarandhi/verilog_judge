`timescale 1ns/1ps
module tb;
  reg [3:0] a, b;
  wire [3:0] y;

  xor_4bit dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'b0000; b = 4'b0000; #5; $display("%b %b %b", a, b, y);
    a = 4'b0000; b = 4'b1111; #5; $display("%b %b %b", a, b, y);
    a = 4'b1111; b = 4'b0000; #5; $display("%b %b %b", a, b, y);
    a = 4'b1111; b = 4'b1111; #5; $display("%b %b %b", a, b, y);
    a = 4'b1000; b = 4'b1111; #5; $display("%b %b %b", a, b, y);
    a = 4'b0101; b = 4'b1010; #5; $display("%b %b %b", a, b, y);
    $finish;
  end
endmodule
