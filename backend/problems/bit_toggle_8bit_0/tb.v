`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  wire [7:0] y;

  bit_toggle_8bit_0 dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'b00000000; #5; $display("%b %b", a, y);
    a = 8'b00000001; #5; $display("%b %b", a, y);
    a = 8'b11111111; #5; $display("%b %b", a, y);
    a = 8'b10101010; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
