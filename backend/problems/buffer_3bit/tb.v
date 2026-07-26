`timescale 1ns/1ps
module tb;
  reg [2:0] a;
  wire [2:0] y;

  buffer_3bit dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 3'b000; #5; $display("%b %b", a, y);
    a = 3'b001; #5; $display("%b %b", a, y);
    a = 3'b111; #5; $display("%b %b", a, y);
    a = 3'b101; #5; $display("%b %b", a, y);
    $finish;
  end
endmodule
