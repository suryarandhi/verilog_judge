`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg [1:0] index;
  reg [7:0] tag;
  reg [15:0] data_in;
  reg write_en;
  wire [15:0] data_out;
  wire hit;

  cache_line_buffer dut(.clk(clk), .rst(rst), .index(index), .tag(tag), .data_in(data_in), .write_en(write_en), .data_out(data_out), .hit(hit));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; index = 2'd0; tag = 8'd0; data_in = 16'd0; write_en = 1'd0; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    rst = 0; index = 2'd1; tag = 8'd1; data_in = 16'd1; write_en = 1'd1; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    rst = 0; index = 2'd3; tag = 8'd255; data_in = 16'd65535; write_en = 1'd1; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    rst = 0; index = 2'd2; tag = 8'd170; data_in = 16'd170; write_en = 1'd0; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    rst = 0; index = 2'd2; tag = 8'd2; data_in = 16'd2; write_en = 1'd2; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    rst = 0; index = 2'd3; tag = 8'd3; data_in = 16'd3; write_en = 1'd3; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    rst = 0; index = 2'd1; tag = 8'd127; data_in = 16'd32767; write_en = 1'd0; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    rst = 0; index = 2'd2; tag = 8'd170; data_in = 16'd65450; write_en = 1'd0; #1; @(posedge clk); #1; $display("%b %b", data_out, hit);
    $finish;
  end
endmodule
