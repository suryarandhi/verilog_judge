`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg [7:0] b;
  reg [2:0] op;
  wire [7:0] result;
  wire zero;

  simple_alu_8bit dut(.a(a), .b(b), .op(op), .result(result), .zero(zero));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; op = 3'd0; #1; $display("%b %b", result, zero);
    a = 8'd1; b = 8'd1; op = 3'd1; #1; $display("%b %b", result, zero);
    a = 8'd255; b = 8'd255; op = 3'd7; #1; $display("%b %b", result, zero);
    a = 8'd170; b = 8'd170; op = 3'd2; #1; $display("%b %b", result, zero);
    a = 8'd2; b = 8'd2; op = 3'd2; #1; $display("%b %b", result, zero);
    a = 8'd3; b = 8'd3; op = 3'd3; #1; $display("%b %b", result, zero);
    a = 8'd127; b = 8'd127; op = 3'd3; #1; $display("%b %b", result, zero);
    a = 8'd170; b = 8'd170; op = 3'd2; #1; $display("%b %b", result, zero);
    $finish;
  end
endmodule
