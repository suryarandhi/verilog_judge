`timescale 1ns/1ps
module tb;
  reg [31:0] a;
  wire y;

  bit_select_32bit_3 dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 32'b00000000000000000000000000000000; #5; $display("%b %b", a, y);
    a = 32'b00000000000000000000000000001000; #5; $display("%b %b", a, y);
    a = 32'b11111111111111111111111111111111; #5; $display("%b %b", a, y);
    a = 32'b10101010101010101010101010101010; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
