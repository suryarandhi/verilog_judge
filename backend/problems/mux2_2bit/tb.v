`timescale 1ns/1ps
module tb;
  reg [1:0] a, b;
  reg sel;
  wire [1:0] y;

  mux2_2bit dut(.a(a), .b(b), .sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 2'b00; b = 2'b11; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 2'b00; b = 2'b11; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 2'b01; b = 2'b10; sel = 0; #5; $display("%b %b %b %b", a, b, sel, y);
    a = 2'b01; b = 2'b10; sel = 1; #5; $display("%b %b %b %b", a, b, sel, y);
    $finish;
  end
endmodule
