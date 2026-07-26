`timescale 1ns/1ps
module tb;
  reg [1:0] a, b;
  wire [1:0] sum;
  wire cout;

  adder_2bit dut(.a(a), .b(b), .sum(sum), .cout(cout));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 2'b00; b = 2'b00; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 2'b01; b = 2'b01; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 2'b11; b = 2'b01; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 2'b01; b = 2'b01; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 2'b11; b = 2'b11; #5; $display("%b %b %b %b", a, b, sum, cout);
    $finish;
  end
endmodule
