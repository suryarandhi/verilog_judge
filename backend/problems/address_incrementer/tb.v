`timescale 1ns/1ps
module tb;
  reg [15:0] addr;
  reg incr;
  wire [15:0] next_addr;

  address_incrementer dut(.addr(addr), .incr(incr), .next_addr(next_addr));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    addr = 16'd0; incr = 1'd0; #1; $display("%b", next_addr);
    addr = 16'd1; incr = 1'd1; #1; $display("%b", next_addr);
    addr = 16'd65535; incr = 1'd1; #1; $display("%b", next_addr);
    addr = 16'd170; incr = 1'd0; #1; $display("%b", next_addr);
    addr = 16'd2; incr = 1'd2; #1; $display("%b", next_addr);
    addr = 16'd3; incr = 1'd3; #1; $display("%b", next_addr);
    addr = 16'd32767; incr = 1'd0; #1; $display("%b", next_addr);
    addr = 16'd65450; incr = 1'd0; #1; $display("%b", next_addr);
    $finish;
  end
endmodule
