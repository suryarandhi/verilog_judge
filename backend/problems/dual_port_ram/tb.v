`timescale 1ns/1ps
module tb;
  reg clk;
  reg wr_en;
  reg [3:0] wr_addr;
  reg [7:0] wr_data;
  reg [3:0] rd_addr;
  wire [7:0] rd_data;

  dual_port_ram dut(.clk(clk), .wr_en(wr_en), .wr_addr(wr_addr), .wr_data(wr_data), .rd_addr(rd_addr), .rd_data(rd_data));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    wr_en = 0; wr_addr = 4'd0; wr_data = 8'd0; rd_addr = 4'd0; #1; @(posedge clk); #1; $display("%b", rd_data);
    wr_en = 1; wr_addr = 4'd1; wr_data = 8'd1; rd_addr = 4'd1; #1; @(posedge clk); #1; $display("%b", rd_data);
    wr_en = 0; wr_addr = 4'd15; wr_data = 8'd255; rd_addr = 4'd15; #1; @(posedge clk); #1; $display("%b", rd_data);
    wr_en = 1; wr_addr = 4'd10; wr_data = 8'd170; rd_addr = 4'd10; #1; @(posedge clk); #1; $display("%b", rd_data);
    wr_en = 0; wr_addr = 4'd2; wr_data = 8'd2; rd_addr = 4'd2; #1; @(posedge clk); #1; $display("%b", rd_data);
    wr_en = 1; wr_addr = 4'd3; wr_data = 8'd3; rd_addr = 4'd3; #1; @(posedge clk); #1; $display("%b", rd_data);
    wr_en = 0; wr_addr = 4'd7; wr_data = 8'd127; rd_addr = 4'd7; #1; @(posedge clk); #1; $display("%b", rd_data);
    wr_en = 1; wr_addr = 4'd10; wr_data = 8'd170; rd_addr = 4'd10; #1; @(posedge clk); #1; $display("%b", rd_data);
    $finish;
  end
endmodule
