`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg push;
  reg pop;
  reg [7:0] din;
  wire [7:0] dout;
  wire full;
  wire empty;

  circular_buffer dut(.clk(clk), .rst(rst), .push(push), .pop(pop), .din(din), .dout(dout), .full(full), .empty(empty));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; push = 1'd0; pop = 1'd0; din = 8'd0; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; push = 1'd1; pop = 1'd1; din = 8'd1; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; push = 1'd1; pop = 1'd1; din = 8'd255; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; push = 1'd0; pop = 1'd0; din = 8'd170; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; push = 1'd2; pop = 1'd2; din = 8'd2; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; push = 1'd3; pop = 1'd3; din = 8'd3; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; push = 1'd0; pop = 1'd0; din = 8'd127; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; push = 1'd0; pop = 1'd0; din = 8'd170; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    $finish;
  end
endmodule
