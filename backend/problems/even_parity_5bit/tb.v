`timescale 1ns/1ps
module tb;
  reg [4:0] a;
  wire y;

  even_parity_5bit dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 5'b00000; #5; $display("%b %b", a, y);
    a = 5'b00001; #5; $display("%b %b", a, y);
    a = 5'b00011; #5; $display("%b %b", a, y);
    a = 5'b11111; #5; $display("%b %b", a, y);
    a = 5'b10101; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
