`timescale 1ns/1ps
module tb;
  reg [3:0] in;
  wire [1:0] code;
  wire valid;

  priority_encoder_4to2 dut(.in(in), .code(code), .valid(valid));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    in = 4'd0; #1; $display("%b %b", code, valid);
    in = 4'd1; #1; $display("%b %b", code, valid);
    in = 4'd15; #1; $display("%b %b", code, valid);
    in = 4'd10; #1; $display("%b %b", code, valid);
    in = 4'd2; #1; $display("%b %b", code, valid);
    in = 4'd3; #1; $display("%b %b", code, valid);
    in = 4'd7; #1; $display("%b %b", code, valid);
    in = 4'd10; #1; $display("%b %b", code, valid);
    $finish;
  end
endmodule
