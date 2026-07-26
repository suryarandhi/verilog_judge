`timescale 1ns/1ps
module tb;
  reg [2:0] a, b;
  wire [2:0] y;

  xnor_3bit dut(.a(a), .b(b), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 3'b000; b = 3'b000; #5; $display("%b %b %b", a, b, y);
    a = 3'b000; b = 3'b111; #5; $display("%b %b %b", a, b, y);
    a = 3'b111; b = 3'b000; #5; $display("%b %b %b", a, b, y);
    a = 3'b111; b = 3'b111; #5; $display("%b %b %b", a, b, y);
    a = 3'b100; b = 3'b111; #5; $display("%b %b %b", a, b, y);
    a = 3'b010; b = 3'b101; #5; $display("%b %b %b", a, b, y);
    $finish;
  end
endmodule
