`timescale 1ns/1ps
module tb;
  reg [15:0] a, b;
  wire [15:0] diff;
  wire borrow;

  subtractor_16bit dut(.a(a), .b(b), .diff(diff), .borrow(borrow));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 16'b0000000000000000; b = 16'b0000000000000000; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 16'b0000000000000001; b = 16'b0000000000000001; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 16'b1111111111111111; b = 16'b0000000000000001; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 16'b0111111111111111; b = 16'b0101010101010101; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 16'b1111111111111111; b = 16'b1111111111111111; #5; $display("%b %b %b %b", a, b, diff, borrow);
    $finish;
  end
endmodule
