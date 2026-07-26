`timescale 1ns/1ps
module tb;
  wire [0:0] y;
  constant_ones_1bit dut(.y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    #5; $display("%b", y);
    $finish;
  end
endmodule
