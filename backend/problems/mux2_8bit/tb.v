`timescale 1ns/1ps
module tb;
  reg [7:0] a, b;
  reg sel;
  wire [7:0] y;

  mux2_8bit dut(.a(a), .b(b), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'b00000000; b = 8'b11111111; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 8'b00000000; b = 8'b11111111; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 8'b00000001; b = 8'b00000010; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 8'b00000001; b = 8'b00000010; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    $finish;
  end
endmodule
