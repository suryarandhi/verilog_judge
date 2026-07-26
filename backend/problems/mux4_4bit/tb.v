`timescale 1ns/1ps
module tb;
  reg [3:0] a, b, c, d;
  reg [1:0] sel;
  wire [3:0] y;

  mux4_4bit dut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'b0000; b = 4'b0001; c = 4'b1111; d = 4'b1010; sel = 2'b00; #5; $display("%b %b", sel, y);
    a = 4'b0000; b = 4'b0001; c = 4'b1111; d = 4'b1010; sel = 2'b01; #5; $display("%b %b", sel, y);
    a = 4'b0000; b = 4'b0001; c = 4'b1111; d = 4'b1010; sel = 2'b10; #5; $display("%b %b", sel, y);
    a = 4'b0000; b = 4'b0001; c = 4'b1111; d = 4'b1010; sel = 2'b11; #5; $display("%b %b", sel, y);
    $finish;
  end
endmodule
