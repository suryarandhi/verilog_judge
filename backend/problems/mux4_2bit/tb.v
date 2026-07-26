`timescale 1ns/1ps
module tb;
  reg [1:0] a, b, c, d;
  reg [1:0] sel;
  wire [1:0] y;

  mux4_2bit dut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 2'b00; b = 2'b01; c = 2'b11; d = 2'b10; sel = 2'b00; #5; $display("%b %b", sel, y);
    a = 2'b00; b = 2'b01; c = 2'b11; d = 2'b10; sel = 2'b01; #5; $display("%b %b", sel, y);
    a = 2'b00; b = 2'b01; c = 2'b11; d = 2'b10; sel = 2'b10; #5; $display("%b %b", sel, y);
    a = 2'b00; b = 2'b01; c = 2'b11; d = 2'b10; sel = 2'b11; #5; $display("%b %b", sel, y);
    $finish;
  end
endmodule
