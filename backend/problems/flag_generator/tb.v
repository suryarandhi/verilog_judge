`timescale 1ns/1ps
module tb;
  reg [7:0] result;
  reg carry_in;
  wire zero;
  wire negative;
  wire parity;
  wire carry_out;

  flag_generator dut(.result(result), .carry_in(carry_in), .zero(zero), .negative(negative), .parity(parity), .carry_out(carry_out));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    result = 8'd0; carry_in = 1'd0; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    result = 8'd1; carry_in = 1'd1; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    result = 8'd255; carry_in = 1'd1; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    result = 8'd170; carry_in = 1'd0; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    result = 8'd2; carry_in = 1'd2; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    result = 8'd3; carry_in = 1'd3; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    result = 8'd127; carry_in = 1'd0; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    result = 8'd170; carry_in = 1'd0; #1; $display("%b %b %b %b", zero, negative, parity, carry_out);
    $finish;
  end
endmodule
