`timescale 1ns/1ps
module tb;
  reg signed [7:0] a;
  reg signed [7:0] b;
  wire signed [15:0] product;

  fixed_point_multiplier dut(.a(a), .b(b), .product(product));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; #1; $display("%b", product);
    a = 8'd1; b = 8'd1; #1; $display("%b", product);
    a = 8'd255; b = 8'd255; #1; $display("%b", product);
    a = 8'd170; b = 8'd170; #1; $display("%b", product);
    a = 8'd2; b = 8'd2; #1; $display("%b", product);
    a = 8'd3; b = 8'd3; #1; $display("%b", product);
    a = 8'd127; b = 8'd127; #1; $display("%b", product);
    a = 8'd170; b = 8'd170; #1; $display("%b", product);
    $finish;
  end
endmodule
