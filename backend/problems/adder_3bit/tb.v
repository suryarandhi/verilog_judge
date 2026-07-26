`timescale 1ns/1ps
module tb;
  reg [2:0] a, b;
  wire [2:0] sum;
  wire cout;

  adder_3bit dut(.a(a), .b(b), .sum(sum), .cout(cout));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 3'b000; b = 3'b000; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 3'b001; b = 3'b001; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 3'b111; b = 3'b001; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 3'b011; b = 3'b010; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 3'b111; b = 3'b111; #5; $display("%b %b %b %b", a, b, sum, cout);
    $finish;
  end
endmodule
