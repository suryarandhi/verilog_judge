`timescale 1ns/1ps
module tb;
  reg clk;
  reg reset;
  reg in_valid;
  reg [7:0] in_data;
  reg out_ready;
  wire in_ready;
  wire out_valid;
  wire [7:0] out_data;

  ready_valid_skid_buffer dut(.clk(clk), .reset(reset), .in_valid(in_valid), .in_data(in_data), .out_ready(out_ready), .in_ready(in_ready), .out_valid(out_valid), .out_data(out_data));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    reset = 1; in_valid = 0; in_data = 8'd0; out_ready = 0; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    reset = 0; in_valid = 1; in_data = 8'd1; out_ready = 1; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    reset = 0; in_valid = 0; in_data = 8'd255; out_ready = 0; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    reset = 0; in_valid = 1; in_data = 8'd170; out_ready = 1; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    reset = 0; in_valid = 0; in_data = 8'd2; out_ready = 0; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    reset = 0; in_valid = 1; in_data = 8'd3; out_ready = 1; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    reset = 0; in_valid = 0; in_data = 8'd127; out_ready = 0; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    reset = 0; in_valid = 1; in_data = 8'd170; out_ready = 1; #1; @(posedge clk); #1; $display("%b %b %b", in_ready, out_valid, out_data);
    $finish;
  end
endmodule
