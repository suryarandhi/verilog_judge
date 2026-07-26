`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg wr_en;
  reg [9:0] addr;
  reg [7:0] din;
  wire [7:0] dout;

  sram_1kx8 dut(.clk(clk), .rst(rst), .wr_en(wr_en), .addr(addr), .din(din), .dout(dout));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; wr_en = 0; addr = 10'd0; din = 8'd0; #1; @(posedge clk); #1; $display("%b", dout);
    rst = 0; wr_en = 1; addr = 10'd1; din = 8'd1; #1; @(posedge clk); #1; $display("%b", dout);
    rst = 0; wr_en = 0; addr = 10'd1023; din = 8'd255; #1; @(posedge clk); #1; $display("%b", dout);
    rst = 0; wr_en = 1; addr = 10'd170; din = 8'd170; #1; @(posedge clk); #1; $display("%b", dout);
    rst = 0; wr_en = 0; addr = 10'd2; din = 8'd2; #1; @(posedge clk); #1; $display("%b", dout);
    rst = 0; wr_en = 1; addr = 10'd3; din = 8'd3; #1; @(posedge clk); #1; $display("%b", dout);
    rst = 0; wr_en = 0; addr = 10'd511; din = 8'd127; #1; @(posedge clk); #1; $display("%b", dout);
    rst = 0; wr_en = 1; addr = 10'd938; din = 8'd170; #1; @(posedge clk); #1; $display("%b", dout);
    $finish;
  end
endmodule
