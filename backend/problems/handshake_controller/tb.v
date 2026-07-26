`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg req;
  wire ack;

  handshake_controller dut(.clk(clk), .rst(rst), .req(req), .ack(ack));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; req = 1'd0; #1; @(posedge clk); #1; $display("%b", ack);
    rst = 0; req = 1'd1; #1; @(posedge clk); #1; $display("%b", ack);
    rst = 0; req = 1'd1; #1; @(posedge clk); #1; $display("%b", ack);
    rst = 0; req = 1'd0; #1; @(posedge clk); #1; $display("%b", ack);
    rst = 0; req = 1'd2; #1; @(posedge clk); #1; $display("%b", ack);
    rst = 0; req = 1'd3; #1; @(posedge clk); #1; $display("%b", ack);
    rst = 0; req = 1'd0; #1; @(posedge clk); #1; $display("%b", ack);
    rst = 0; req = 1'd0; #1; @(posedge clk); #1; $display("%b", ack);
    $finish;
  end
endmodule
