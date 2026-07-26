`timescale 1ns/1ps
module tb;
  reg [15:0] a, b;
  reg sel;
  wire [15:0] y;

  mux2_16bit dut(.a(a), .b(b), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 16'b0000000000000000; b = 16'b1111111111111111; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 16'b0000000000000000; b = 16'b1111111111111111; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 16'b0000000000000001; b = 16'b0000000000000010; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 16'b0000000000000001; b = 16'b0000000000000010; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    $finish;
  end
endmodule
