`timescale 1ns/1ps
module tb;
  reg [7:0] a;
  reg [7:0] b;
  reg cin;
  wire [7:0] sum;
  wire cout;

  carry_lookahead_adder dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'd0; b = 8'd0; cin = 1'd0; #1; $display("%b %b", sum, cout);
    a = 8'd1; b = 8'd1; cin = 1'd1; #1; $display("%b %b", sum, cout);
    a = 8'd255; b = 8'd255; cin = 1'd1; #1; $display("%b %b", sum, cout);
    a = 8'd170; b = 8'd170; cin = 1'd0; #1; $display("%b %b", sum, cout);
    a = 8'd2; b = 8'd2; cin = 1'd2; #1; $display("%b %b", sum, cout);
    a = 8'd3; b = 8'd3; cin = 1'd3; #1; $display("%b %b", sum, cout);
    a = 8'd127; b = 8'd127; cin = 1'd0; #1; $display("%b %b", sum, cout);
    a = 8'd170; b = 8'd170; cin = 1'd0; #1; $display("%b %b", sum, cout);
    $finish;
  end
endmodule
