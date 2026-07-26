`timescale 1ns/1ps
module tb;
  wire [1:0] y;
  constant_zero_2bit dut(.y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    #5; $display("%b", y);
    $finish;
  end
endmodule
