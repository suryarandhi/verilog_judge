`timescale 1ns/1ps
module tb;
  wire [31:0] y;
  constant_zero_32bit dut(.y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    #5; $display("%b", y);
    $finish;
  end
endmodule
