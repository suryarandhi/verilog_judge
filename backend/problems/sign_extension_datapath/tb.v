`timescale 1ns/1ps
module tb;
  reg [6:0] a;
  wire [15:0] y;

  sign_extension_datapath dut(.a(a), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 7'd0; #1; $display("%b", y);
    a = 7'd1; #1; $display("%b", y);
    a = 7'd127; #1; $display("%b", y);
    a = 7'd42; #1; $display("%b", y);
    a = 7'd2; #1; $display("%b", y);
    a = 7'd3; #1; $display("%b", y);
    a = 7'd63; #1; $display("%b", y);
    a = 7'd42; #1; $display("%b", y);
    $finish;
  end
endmodule
