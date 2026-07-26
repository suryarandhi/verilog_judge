`timescale 1ns/1ps
module tb;
  reg [3:0] a;
  reg [1:0] shamt;
  wire [3:0] y;

  shift_left_4bit dut(.a(a), .shamt(shamt), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'b0001; shamt = 2'b00; #5; $display("%b %b %b", a, shamt, y);
    a = 4'b0001; shamt = 2'b01; #5; $display("%b %b %b", a, shamt, y);
    a = 4'b1111; shamt = 2'b01; #5; $display("%b %b %b", a, shamt, y);
    a = 4'b0101; shamt = 2'b10; #5; $display("%b %b %b", a, shamt, y);
    a = 4'b1000; shamt = 2'b01; #5; $display("%b %b %b", a, shamt, y);
    $finish;
  end
endmodule
