`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg wr_en;
  reg [3:0] addr;
  reg [7:0] data_in;
  reg rd_en;
  reg [3:0] rd_addr;
  wire [7:0] data_out;

  read_after_write_buffer dut(.clk(clk), .rst(rst), .wr_en(wr_en), .addr(addr), .data_in(data_in), .rd_en(rd_en), .rd_addr(rd_addr), .data_out(data_out));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; wr_en = 0; addr = 4'd0; data_in = 8'd0; rd_en = 0; rd_addr = 4'd0; #1; @(posedge clk); #1; $display("%b", data_out);
    rst = 0; wr_en = 1; addr = 4'd1; data_in = 8'd1; rd_en = 1; rd_addr = 4'd1; #1; @(posedge clk); #1; $display("%b", data_out);
    rst = 0; wr_en = 0; addr = 4'd15; data_in = 8'd255; rd_en = 0; rd_addr = 4'd15; #1; @(posedge clk); #1; $display("%b", data_out);
    rst = 0; wr_en = 1; addr = 4'd10; data_in = 8'd170; rd_en = 1; rd_addr = 4'd10; #1; @(posedge clk); #1; $display("%b", data_out);
    rst = 0; wr_en = 0; addr = 4'd2; data_in = 8'd2; rd_en = 0; rd_addr = 4'd2; #1; @(posedge clk); #1; $display("%b", data_out);
    rst = 0; wr_en = 1; addr = 4'd3; data_in = 8'd3; rd_en = 1; rd_addr = 4'd3; #1; @(posedge clk); #1; $display("%b", data_out);
    rst = 0; wr_en = 0; addr = 4'd7; data_in = 8'd127; rd_en = 0; rd_addr = 4'd7; #1; @(posedge clk); #1; $display("%b", data_out);
    rst = 0; wr_en = 1; addr = 4'd10; data_in = 8'd170; rd_en = 1; rd_addr = 4'd10; #1; @(posedge clk); #1; $display("%b", data_out);
    $finish;
  end
endmodule
