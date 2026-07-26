`timescale 1ns/1ps
module tb;
  reg [1:0] a, b;
  wire [1:0] y;

  xnor_2bit dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 2'b00; b = 2'b00; #5; $display("%b %b %b", a, b, y);
    a = 2'b00; b = 2'b11; #5; $display("%b %b %b", a, b, y);
    a = 2'b11; b = 2'b00; #5; $display("%b %b %b", a, b, y);
    a = 2'b11; b = 2'b11; #5; $display("%b %b %b", a, b, y);
    a = 2'b10; b = 2'b11; #5; $display("%b %b %b", a, b, y);
    a = 2'b01; b = 2'b10; #5; $display("%b %b %b", a, b, y);
    $finish;
  end
endmodule
