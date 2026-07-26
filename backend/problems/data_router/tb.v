`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] c;
  reg [7:0] d;
  reg [1:0] sel;
  wire [7:0] y;

  data_router dut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd0; sel = 0; #1; $display("%b", y);
    a = 8'd1; b = 8'd1; c = 8'd1; d = 8'd1; sel = 1; #1; $display("%b", y);
    a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd255; sel = 0; #1; $display("%b", y);
    a = 8'd170; b = 8'd170; c = 8'd170; d = 8'd170; sel = 1; #1; $display("%b", y);
    a = 8'd2; b = 8'd2; c = 8'd2; d = 8'd2; sel = 0; #1; $display("%b", y);
    a = 8'd3; b = 8'd3; c = 8'd3; d = 8'd3; sel = 1; #1; $display("%b", y);
    a = 8'd127; b = 8'd127; c = 8'd127; d = 8'd127; sel = 0; #1; $display("%b", y);
    a = 8'd170; b = 8'd170; c = 8'd170; d = 8'd170; sel = 1; #1; $display("%b", y);
    $finish;
  end
endmodule
