`timescale 1ns/1ps
module tb;
  reg [7:0] value;
  wire zero;

  zero_flag_unit dut(.value(value), .zero(zero));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    value = 8'd0; #1; $display("%b", zero);
    value = 8'd1; #1; $display("%b", zero);
    value = 8'd255; #1; $display("%b", zero);
    value = 8'd170; #1; $display("%b", zero);
    value = 8'd2; #1; $display("%b", zero);
    value = 8'd3; #1; $display("%b", zero);
    value = 8'd127; #1; $display("%b", zero);
    value = 8'd170; #1; $display("%b", zero);
    $finish;
  end
endmodule
