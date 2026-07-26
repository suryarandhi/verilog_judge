`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg pulse_in;
  wire pulse_out;

  pulse_stretcher dut(.clk(clk), .rst(rst), .pulse_in(pulse_in), .pulse_out(pulse_out));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; pulse_in = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse_out);
    rst = 0; pulse_in = 1'd1; #1; @(posedge clk); #1; $display("%b", pulse_out);
    rst = 0; pulse_in = 1'd1; #1; @(posedge clk); #1; $display("%b", pulse_out);
    rst = 0; pulse_in = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse_out);
    rst = 0; pulse_in = 1'd2; #1; @(posedge clk); #1; $display("%b", pulse_out);
    rst = 0; pulse_in = 1'd3; #1; @(posedge clk); #1; $display("%b", pulse_out);
    rst = 0; pulse_in = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse_out);
    rst = 0; pulse_in = 1'd0; #1; @(posedge clk); #1; $display("%b", pulse_out);
    $finish;
  end
endmodule
