`timescale 1ns/1ps
module tb;
  reg [7:0] one_hot;
  wire [2:0] code;
  wire valid;

  one_hot_to_binary dut(.one_hot(one_hot), .code(code), .valid(valid));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    one_hot = 8'd0; #1; $display("%b %b", code, valid);
    one_hot = 8'd1; #1; $display("%b %b", code, valid);
    one_hot = 8'd255; #1; $display("%b %b", code, valid);
    one_hot = 8'd170; #1; $display("%b %b", code, valid);
    one_hot = 8'd2; #1; $display("%b %b", code, valid);
    one_hot = 8'd3; #1; $display("%b %b", code, valid);
    one_hot = 8'd127; #1; $display("%b %b", code, valid);
    one_hot = 8'd170; #1; $display("%b %b", code, valid);
    $finish;
  end
endmodule
