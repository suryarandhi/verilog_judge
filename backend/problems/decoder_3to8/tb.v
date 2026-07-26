`timescale 1ns/1ps
module tb;
  reg [2:0] sel;
  wire [7:0] y;

  decoder_3to8 dut(.sel(sel), .y(y));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    sel = 0; #1; $display("%b", y);
    sel = 1; #1; $display("%b", y);
    sel = 0; #1; $display("%b", y);
    sel = 1; #1; $display("%b", y);
    sel = 0; #1; $display("%b", y);
    sel = 1; #1; $display("%b", y);
    sel = 0; #1; $display("%b", y);
    sel = 1; #1; $display("%b", y);
    $finish;
  end
endmodule
