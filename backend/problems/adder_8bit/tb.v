`timescale 1ns/1ps
module tb;
  reg [7:0] a, b;
  wire [7:0] sum;
  wire cout;

  adder_8bit dut(.a(a), .b(b), .sum(sum), .cout(cout));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    a = 8'b00000000; b = 8'b00000000; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 8'b00000001; b = 8'b00000001; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 8'b11111111; b = 8'b00000001; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 8'b01111111; b = 8'b01010101; #5; $display("%b %b %b %b", a, b, sum, cout);
    a = 8'b11111111; b = 8'b11111111; #5; $display("%b %b %b %b", a, b, sum, cout);
    $finish;
  end
endmodule
