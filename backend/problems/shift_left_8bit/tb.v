`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg [2:0] shamt;
  wire [7:0] y;

  shift_left_8bit dut(.a(a), .shamt(shamt), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'b00000001; shamt = 3'b000; #5; $display("%b %b %b", a, shamt, y);
    a = 8'b00000001; shamt = 3'b001; #5; $display("%b %b %b", a, shamt, y);
    a = 8'b11111111; shamt = 3'b001; #5; $display("%b %b %b", a, shamt, y);
    a = 8'b01010101; shamt = 3'b010; #5; $display("%b %b %b", a, shamt, y);
    a = 8'b10000000; shamt = 3'b011; #5; $display("%b %b %b", a, shamt, y);
    $finish;
  end
endmodule
