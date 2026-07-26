`timescale 1ns/1ps
module tb;
  reg [3:0] bcd;
  wire [6:0] seg;

  bcd_to_7seg dut(.bcd(bcd), .seg(seg));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    bcd = 4'd0; #1; $display("%b", seg);
    bcd = 4'd1; #1; $display("%b", seg);
    bcd = 4'd15; #1; $display("%b", seg);
    bcd = 4'd10; #1; $display("%b", seg);
    bcd = 4'd2; #1; $display("%b", seg);
    bcd = 4'd3; #1; $display("%b", seg);
    bcd = 4'd7; #1; $display("%b", seg);
    bcd = 4'd10; #1; $display("%b", seg);
    $finish;
  end
endmodule
