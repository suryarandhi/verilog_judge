`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg write_en;
  reg read_en;
  reg [7:0] din;
  wire [7:0] dout;
  wire full;
  wire empty;

  pointer_based_buffer dut(.clk(clk), .rst(rst), .write_en(write_en), .read_en(read_en), .din(din), .dout(dout), .full(full), .empty(empty));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; write_en = 1'd0; read_en = 1'd0; din = 8'd0; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; write_en = 1'd1; read_en = 1'd1; din = 8'd1; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; write_en = 1'd1; read_en = 1'd1; din = 8'd255; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; write_en = 1'd0; read_en = 1'd0; din = 8'd170; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; write_en = 1'd2; read_en = 1'd2; din = 8'd2; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; write_en = 1'd3; read_en = 1'd3; din = 8'd3; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; write_en = 1'd0; read_en = 1'd0; din = 8'd127; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    rst = 0; write_en = 1'd0; read_en = 1'd0; din = 8'd170; #1; @(posedge clk); #1; $display("%b %b %b", dout, full, empty);
    $finish;
  end
endmodule
