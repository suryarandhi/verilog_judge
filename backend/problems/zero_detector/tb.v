`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  wire is_zero;

  zero_detector dut(.a(a), .is_zero(is_zero));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; #1; $display("%b", is_zero);
    a = 8'd1; #1; $display("%b", is_zero);
    a = 8'd255; #1; $display("%b", is_zero);
    a = 8'd170; #1; $display("%b", is_zero);
    a = 8'd2; #1; $display("%b", is_zero);
    a = 8'd3; #1; $display("%b", is_zero);
    a = 8'd127; #1; $display("%b", is_zero);
    a = 8'd170; #1; $display("%b", is_zero);
    $finish;
  end
endmodule
