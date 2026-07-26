`timescale 1ns/1ps
module tb;
  reg a, b, cin;
  wire sum, cout;

  full_adder dut(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);

    a = 0; b = 0; cin = 0; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    a = 0; b = 0; cin = 1; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    a = 0; b = 1; cin = 0; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    a = 0; b = 1; cin = 1; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    a = 1; b = 0; cin = 0; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    a = 1; b = 0; cin = 1; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    a = 1; b = 1; cin = 0; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    a = 1; b = 1; cin = 1; #5; $display("%b %b %b %b %b", a, b, cin, sum, cout);
    $finish;
  end
endmodule
