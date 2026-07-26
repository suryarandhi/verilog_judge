`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg in_bit;
  wire pulse;

  bit_pulse_generator dut(.clk(clk), .rst(rst), .in_bit(in_bit), .pulse(pulse));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; in_bit = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; in_bit = 1'd1; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; in_bit = 1'd1; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; in_bit = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; in_bit = 1'd2; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; in_bit = 1'd3; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; in_bit = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; in_bit = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    $finish;
  end
endmodule
