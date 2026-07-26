`timescale 1ns/1ps
module tb;
  reg [15:0] a, b, c, d;
  reg [1:0] sel;
  wire [15:0] y;

  mux4_16bit dut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 16'b0000000000000000; b = 16'b0000000000000001; c = 16'b1111111111111111; d = 16'b1010101010101010; sel = 2'b00; #5; $display("%b %b", sel, y);
    a = 16'b0000000000000000; b = 16'b0000000000000001; c = 16'b1111111111111111; d = 16'b1010101010101010; sel = 2'b01; #5; $display("%b %b", sel, y);
    a = 16'b0000000000000000; b = 16'b0000000000000001; c = 16'b1111111111111111; d = 16'b1010101010101010; sel = 2'b10; #5; $display("%b %b", sel, y);
    a = 16'b0000000000000000; b = 16'b0000000000000001; c = 16'b1111111111111111; d = 16'b1010101010101010; sel = 2'b11; #5; $display("%b %b", sel, y);
    $finish;
  end
endmodule
