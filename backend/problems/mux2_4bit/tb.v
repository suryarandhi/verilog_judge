`timescale 1ns/1ps
module tb;
  reg [3:0] a, b;
  reg sel;
  wire [3:0] y;

  mux2_4bit dut(.a(a), .b(b), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 4'b0000; b = 4'b1111; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 4'b0000; b = 4'b1111; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 4'b0001; b = 4'b0010; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 4'b0001; b = 4'b0010; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    $finish;
  end
endmodule
