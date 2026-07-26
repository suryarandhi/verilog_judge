`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  wire msb_one;

  detect_msb_one dut(.a(a), .msb_one(msb_one));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; #1; $display("%b", msb_one);
    a = 8'd1; #1; $display("%b", msb_one);
    a = 8'd255; #1; $display("%b", msb_one);
    a = 8'd170; #1; $display("%b", msb_one);
    a = 8'd2; #1; $display("%b", msb_one);
    a = 8'd3; #1; $display("%b", msb_one);
    a = 8'd127; #1; $display("%b", msb_one);
    a = 8'd170; #1; $display("%b", msb_one);
    $finish;
  end
endmodule
