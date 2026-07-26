`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  wire y;

  bit_select_8bit_5 dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'b00000000; #5; $display("%b %b", a, y);
    a = 8'b00100000; #5; $display("%b %b", a, y);
    a = 8'b11111111; #5; $display("%b %b", a, y);
    a = 8'b10101010; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
