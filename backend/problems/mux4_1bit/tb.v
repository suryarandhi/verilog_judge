`timescale 1ns/1ps
module tb;
  reg [0:0] a, b, c, d;
  reg [1:0] sel;
  wire [0:0] y;

  mux4_1bit dut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 1'b0; b = 1'b1; c = 1'b1; d = 1'b1; sel = 2'b00; #5; $display("%b %b", sel, y);
    a = 1'b0; b = 1'b1; c = 1'b1; d = 1'b1; sel = 2'b01; #5; $display("%b %b", sel, y);
    a = 1'b0; b = 1'b1; c = 1'b1; d = 1'b1; sel = 2'b10; #5; $display("%b %b", sel, y);
    a = 1'b0; b = 1'b1; c = 1'b1; d = 1'b1; sel = 2'b11; #5; $display("%b %b", sel, y);
    $finish;
  end
endmodule
