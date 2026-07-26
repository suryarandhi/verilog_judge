`timescale 1ns/1ps
module tb;
  reg signed [15:0] a;
  reg [3:0] shamt;
  wire [15:0] y;

  arithmetic_shift_unit dut(.a(a), .shamt(shamt), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 16'd0; shamt = 4'd0; #1; $display("%b", y);
    a = 16'd1; shamt = 4'd1; #1; $display("%b", y);
    a = 16'd65535; shamt = 4'd15; #1; $display("%b", y);
    a = 16'd170; shamt = 4'd10; #1; $display("%b", y);
    a = 16'd2; shamt = 4'd2; #1; $display("%b", y);
    a = 16'd3; shamt = 4'd3; #1; $display("%b", y);
    a = 16'd32767; shamt = 4'd7; #1; $display("%b", y);
    a = 16'd65450; shamt = 4'd10; #1; $display("%b", y);
    $finish;
  end
endmodule
