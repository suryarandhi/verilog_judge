`timescale 1ns/1ps
module tb;
  reg [7:0] value;
  reg permit;
  wire violation;

  formal_property_checker dut(.value(value), .permit(permit), .violation(violation));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    value = 8'd0; permit = 0; #1; $display("%b", violation);
    value = 8'd1; permit = 1; #1; $display("%b", violation);
    value = 8'd255; permit = 0; #1; $display("%b", violation);
    value = 8'd170; permit = 1; #1; $display("%b", violation);
    value = 8'd2; permit = 0; #1; $display("%b", violation);
    value = 8'd3; permit = 1; #1; $display("%b", violation);
    value = 8'd127; permit = 0; #1; $display("%b", violation);
    value = 8'd170; permit = 1; #1; $display("%b", violation);
    $finish;
  end
endmodule
