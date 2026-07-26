`timescale 1ns/1ps
module tb;
  reg [31:0] a;
  reg [4:0] shamt;
  reg dir;
  wire [31:0] y;

  barrel_shifter_32bit dut(.a(a), .shamt(shamt), .dir(dir), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 32'd0; shamt = 5'd0; dir = 0; #1; $display("%b", y);
    a = 32'd1; shamt = 5'd1; dir = 1; #1; $display("%b", y);
    a = 32'd4294967295; shamt = 5'd31; dir = 0; #1; $display("%b", y);
    a = 32'd170; shamt = 5'd10; dir = 1; #1; $display("%b", y);
    a = 32'd2; shamt = 5'd2; dir = 0; #1; $display("%b", y);
    a = 32'd3; shamt = 5'd3; dir = 1; #1; $display("%b", y);
    a = 32'd2147483647; shamt = 5'd15; dir = 0; #1; $display("%b", y);
    a = 32'd4294967210; shamt = 5'd10; dir = 1; #1; $display("%b", y);
    $finish;
  end
endmodule
