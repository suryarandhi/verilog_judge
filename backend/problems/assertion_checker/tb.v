`timescale 1ns/1ps
module tb;
  reg [3:0] value;
  wire fault;

  assertion_checker dut(.value(value), .fault(fault));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    value = 4'd0; #1; $display("%b", fault);
    value = 4'd1; #1; $display("%b", fault);
    value = 4'd15; #1; $display("%b", fault);
    value = 4'd10; #1; $display("%b", fault);
    value = 4'd2; #1; $display("%b", fault);
    value = 4'd3; #1; $display("%b", fault);
    value = 4'd7; #1; $display("%b", fault);
    value = 4'd10; #1; $display("%b", fault);
    $finish;
  end
endmodule
