`timescale 1ns/1ps
module tb;
  reg [3:0] a;
  reg [3:0] b;
  wire [7:0] product;

  unsigned_multiplier_4x4 dut(.a(a), .b(b), .product(product));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'd0; b = 4'd0; #1; $display("%b", product);
    a = 4'd1; b = 4'd1; #1; $display("%b", product);
    a = 4'd15; b = 4'd15; #1; $display("%b", product);
    a = 4'd10; b = 4'd10; #1; $display("%b", product);
    a = 4'd2; b = 4'd2; #1; $display("%b", product);
    a = 4'd3; b = 4'd3; #1; $display("%b", product);
    a = 4'd7; b = 4'd7; #1; $display("%b", product);
    a = 4'd10; b = 4'd10; #1; $display("%b", product);
    $finish;
  end
endmodule
