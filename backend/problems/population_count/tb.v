`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  wire [3:0] count;

  population_count dut(.a(a), .count(count));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; #1; $display("%b", count);
    a = 8'd1; #1; $display("%b", count);
    a = 8'd255; #1; $display("%b", count);
    a = 8'd170; #1; $display("%b", count);
    a = 8'd2; #1; $display("%b", count);
    a = 8'd3; #1; $display("%b", count);
    a = 8'd127; #1; $display("%b", count);
    a = 8'd170; #1; $display("%b", count);
    $finish;
  end
endmodule
