`timescale 1ns/1ps
module tb;
  reg [1:0] a, b;
  wire [1:0] diff;
  wire borrow;

  subtractor_2bit dut(.a(a), .b(b), .diff(diff), .borrow(borrow));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 2'b00; b = 2'b00; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 2'b01; b = 2'b01; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 2'b11; b = 2'b01; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 2'b01; b = 2'b01; #5; $display("%b %b %b %b", a, b, diff, borrow);
    a = 2'b11; b = 2'b11; #5; $display("%b %b %b %b", a, b, diff, borrow);
    $finish;
  end
endmodule
