`timescale 1ns/1ps
module tb;
  reg signed [7:0] value;
  reg branch_neg;
  wire taken;

  branch_condition_unit dut(.value(value), .branch_neg(branch_neg), .taken(taken));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    value = 8'd0; branch_neg = 1'd0; #1; $display("%b", taken);
    value = 8'd1; branch_neg = 1'd1; #1; $display("%b", taken);
    value = 8'd255; branch_neg = 1'd1; #1; $display("%b", taken);
    value = 8'd170; branch_neg = 1'd0; #1; $display("%b", taken);
    value = 8'd2; branch_neg = 1'd2; #1; $display("%b", taken);
    value = 8'd3; branch_neg = 1'd3; #1; $display("%b", taken);
    value = 8'd127; branch_neg = 1'd0; #1; $display("%b", taken);
    value = 8'd170; branch_neg = 1'd0; #1; $display("%b", taken);
    $finish;
  end
endmodule
