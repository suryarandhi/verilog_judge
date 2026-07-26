`timescale 1ns/1ps
module tb;
  reg [15:0] a;
  reg [3:0] shamt;
  wire [15:0] y;

  shift_right_16bit dut(.a(a), .shamt(shamt), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 16'b0000000000000001; shamt = 4'b0000; #5; $display("%b %b %b", a, shamt, y);
    a = 16'b0000000000000001; shamt = 4'b0001; #5; $display("%b %b %b", a, shamt, y);
    a = 16'b1111111111111111; shamt = 4'b0001; #5; $display("%b %b %b", a, shamt, y);
    a = 16'b0101010101010101; shamt = 4'b0010; #5; $display("%b %b %b", a, shamt, y);
    a = 16'b1000000000000000; shamt = 4'b0011; #5; $display("%b %b %b", a, shamt, y);
    $finish;
  end
endmodule
