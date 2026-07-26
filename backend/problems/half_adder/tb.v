`timescale 1ns/1ps
module tb;
  reg a, b;
  wire sum, carry;

  half_adder dut(.a(a), .b(b), .sum(sum), .carry(carry));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);

    a = 0; b = 0; #5; $display("%b %b %b %b", a, b, sum, carry);
    a = 0; b = 1; #5; $display("%b %b %b %b", a, b, sum, carry);
    a = 1; b = 0; #5; $display("%b %b %b %b", a, b, sum, carry);
    a = 1; b = 1; #5; $display("%b %b %b %b", a, b, sum, carry);
    $finish;
  end
endmodule
