`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg [7:0] b;
  wire g;
  wire p;

  carry_generate_combiner dut(.a(a), .b(b), .g(g), .p(p));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; #1; $display("%b %b", g, p);
    a = 8'd1; b = 8'd1; #1; $display("%b %b", g, p);
    a = 8'd255; b = 8'd255; #1; $display("%b %b", g, p);
    a = 8'd170; b = 8'd170; #1; $display("%b %b", g, p);
    a = 8'd2; b = 8'd2; #1; $display("%b %b", g, p);
    a = 8'd3; b = 8'd3; #1; $display("%b %b", g, p);
    a = 8'd127; b = 8'd127; #1; $display("%b %b", g, p);
    a = 8'd170; b = 8'd170; #1; $display("%b %b", g, p);
    $finish;
  end
endmodule
