`timescale 1ns/1ps
module tb;
  reg signed [7:0] a;
  reg signed [7:0] b;
  reg sel;
  wire signed [7:0] y;
  wire negative;

  signed_magnitude_selector dut(.a(a), .b(b), .sel(sel), .y(y), .negative(negative));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; sel = 0; #1; $display("%b %b", y, negative);
    a = 8'd1; b = 8'd1; sel = 1; #1; $display("%b %b", y, negative);
    a = 8'd255; b = 8'd255; sel = 0; #1; $display("%b %b", y, negative);
    a = 8'd170; b = 8'd170; sel = 1; #1; $display("%b %b", y, negative);
    a = 8'd2; b = 8'd2; sel = 0; #1; $display("%b %b", y, negative);
    a = 8'd3; b = 8'd3; sel = 1; #1; $display("%b %b", y, negative);
    a = 8'd127; b = 8'd127; sel = 0; #1; $display("%b %b", y, negative);
    a = 8'd170; b = 8'd170; sel = 1; #1; $display("%b %b", y, negative);
    $finish;
  end
endmodule
