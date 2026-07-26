`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg serial_in;
  wire frame_valid;

  serial_frame_detector dut(.clk(clk), .rst(rst), .serial_in(serial_in), .frame_valid(frame_valid));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", frame_valid);
    rst = 0; serial_in = 1'd1; #1; @(posedge clk); #1; $display("%b", frame_valid);
    rst = 0; serial_in = 1'd1; #1; @(posedge clk); #1; $display("%b", frame_valid);
    rst = 0; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", frame_valid);
    rst = 0; serial_in = 1'd2; #1; @(posedge clk); #1; $display("%b", frame_valid);
    rst = 0; serial_in = 1'd3; #1; @(posedge clk); #1; $display("%b", frame_valid);
    rst = 0; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", frame_valid);
    rst = 0; serial_in = 1'd0; #1; @(posedge clk); #1; $display("%b", frame_valid);
    $finish;
  end
endmodule
