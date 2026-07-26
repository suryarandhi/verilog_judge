`timescale 1ns/1ps
module tb;
  reg [7:0] a, b;
  wire [7:0] y;

  or_8bit dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'b00000000; b = 8'b00000000; #5; $display("%b %b %b", a, b, y);
    a = 8'b00000000; b = 8'b11111111; #5; $display("%b %b %b", a, b, y);
    a = 8'b11111111; b = 8'b00000000; #5; $display("%b %b %b", a, b, y);
    a = 8'b11111111; b = 8'b11111111; #5; $display("%b %b %b", a, b, y);
    a = 8'b10000000; b = 8'b11111111; #5; $display("%b %b %b", a, b, y);
    a = 8'b01010101; b = 8'b10101010; #5; $display("%b %b %b", a, b, y);
    $finish;
  end
endmodule
