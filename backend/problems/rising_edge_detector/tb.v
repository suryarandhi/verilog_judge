`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg signal;
  wire pulse;

  rising_edge_detector dut(.clk(clk), .rst(rst), .signal(signal), .pulse(pulse));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; signal = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; signal = 1'd1; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; signal = 1'd1; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; signal = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; signal = 1'd2; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; signal = 1'd3; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; signal = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    rst = 0; signal = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse);
    $finish;
  end
endmodule
