`timescale 1ns/1ps
module tb;
  reg clk;
  reg rst;
  reg coin5;
  reg coin10;
  wire dispense;

  vending_machine_controller dut(.clk(clk), .rst(rst), .coin5(coin5), .coin10(coin10), .dispense(dispense));
  initial begin clk = 0; forever #5 clk = ~clk; end

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    rst = 1; coin5 = 1'd0; coin10 = 1'd0; #1; @(posedge clk); #1; $display("%b", dispense);
    rst = 0; coin5 = 1'd1; coin10 = 1'd1; #1; @(posedge clk); #1; $display("%b", dispense);
    rst = 0; coin5 = 1'd1; coin10 = 1'd1; #1; @(posedge clk); #1; $display("%b", dispense);
    rst = 0; coin5 = 1'd0; coin10 = 1'd0; #1; @(posedge clk); #1; $display("%b", dispense);
    rst = 0; coin5 = 1'd2; coin10 = 1'd2; #1; @(posedge clk); #1; $display("%b", dispense);
    rst = 0; coin5 = 1'd3; coin10 = 1'd3; #1; @(posedge clk); #1; $display("%b", dispense);
    rst = 0; coin5 = 1'd0; coin10 = 1'd0; #1; @(posedge clk); #1; $display("%b", dispense);
    rst = 0; coin5 = 1'd0; coin10 = 1'd0; #1; @(posedge clk); #1; $display("%b", dispense);
    $finish;
  end
endmodule
