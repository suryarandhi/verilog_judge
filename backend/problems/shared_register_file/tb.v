`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg write_en;
  reg [2:0] write_addr;
  reg [7:0] write_data;
  reg [2:0] read_addr_a;
  reg [2:0] read_addr_b;
  wire [7:0] read_data_a;
  wire [7:0] read_data_b;

  shared_register_file dut(.clk(clk), .rst(rst), .write_en(write_en), .write_addr(write_addr), .write_data(write_data), .read_addr_a(read_addr_a), .read_addr_b(read_addr_b), .read_data_a(read_data_a), .read_data_b(read_data_b));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; write_en = 1'd0; write_addr = 3'd0; write_data = 8'd0; read_addr_a = 3'd0; read_addr_b = 3'd0; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    rst = 0; write_en = 1'd1; write_addr = 3'd1; write_data = 8'd1; read_addr_a = 3'd1; read_addr_b = 3'd1; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    rst = 0; write_en = 1'd1; write_addr = 3'd7; write_data = 8'd255; read_addr_a = 3'd7; read_addr_b = 3'd7; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    rst = 0; write_en = 1'd0; write_addr = 3'd2; write_data = 8'd170; read_addr_a = 3'd2; read_addr_b = 3'd2; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    rst = 0; write_en = 1'd2; write_addr = 3'd2; write_data = 8'd2; read_addr_a = 3'd2; read_addr_b = 3'd2; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    rst = 0; write_en = 1'd3; write_addr = 3'd3; write_data = 8'd3; read_addr_a = 3'd3; read_addr_b = 3'd3; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    rst = 0; write_en = 1'd0; write_addr = 3'd3; write_data = 8'd127; read_addr_a = 3'd3; read_addr_b = 3'd3; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    rst = 0; write_en = 1'd0; write_addr = 3'd2; write_data = 8'd170; read_addr_a = 3'd2; read_addr_b = 3'd2; #1; @(posedge clk); #1; $display("%b %b", read_data_a, read_data_b);
    $finish;
  end
endmodule
