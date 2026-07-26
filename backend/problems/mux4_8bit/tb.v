`timescale 1ns/1ps
module tb;
  reg [7:0] a, b, c, d;
  reg [1:0] sel;
  wire [7:0] y;

  mux4_8bit dut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'b00000000; b = 8'b00000001; c = 8'b11111111; d = 8'b10101010; sel = 2'b00; #5; $display("%b %b", sel, y);
    a = 8'b00000000; b = 8'b00000001; c = 8'b11111111; d = 8'b10101010; sel = 2'b01; #5; $display("%b %b", sel, y);
    a = 8'b00000000; b = 8'b00000001; c = 8'b11111111; d = 8'b10101010; sel = 2'b10; #5; $display("%b %b", sel, y);
    a = 8'b00000000; b = 8'b00000001; c = 8'b11111111; d = 8'b10101010; sel = 2'b11; #5; $display("%b %b", sel, y);
    $finish;
  end
endmodule
