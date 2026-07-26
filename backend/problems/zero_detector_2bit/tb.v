`timescale 1ns/1ps
module tb;
  reg [1:0] a;
  wire y;

  zero_detector_2bit dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 2'b00; #5; $display("%b %b", a, y);
    a = 2'b01; #5; $display("%b %b", a, y);
    a = 2'b11; #5; $display("%b %b", a, y);
    a = 2'b10; #5; $display("%b %b", a, y);
    a = 2'b10; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
