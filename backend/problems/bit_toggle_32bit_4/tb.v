`timescale 1ns/1ps
module tb;
  reg [31:0] a;
  wire [31:0] y;

  bit_toggle_32bit_4 dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 32'b00000000000000000000000000000000; #5; $display("%b %b", a, y);
    a = 32'b00000000000000000000000000010000; #5; $display("%b %b", a, y);
    a = 32'b11111111111111111111111111111111; #5; $display("%b %b", a, y);
    a = 32'b10101010101010101010101010101010; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
