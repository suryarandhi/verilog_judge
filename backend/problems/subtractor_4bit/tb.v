`timescale 1ns/1ps
module tb;
  reg [3:0] a, b;
  wire [3:0] diff;
  wire borrow;

  subtractor_4bit dut(.a(a), .b(b), .diff(diff), .borrow(borrow));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'b0000; b = 4'b0000; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 4'b0001; b = 4'b0001; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 4'b1111; b = 4'b0001; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 4'b0111; b = 4'b0101; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 4'b1111; b = 4'b1111; #5; $display("%b %b %b %b", a, b, diff, borrow);
    $finish;
  end
endmodule
