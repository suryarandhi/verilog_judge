`timescale 1ns/1ps
module tb;
  reg [31:0] data_in;
  wire [31:0] data_out;

  byte_swap_32 dut(.data_in(data_in), .data_out(data_out));

  initial begin
    $dumpfile("simulation.vcd");
    $dumpvars(0, tb);
    data_in = 32'd0; #1; $display("%b", data_out);
    data_in = 32'd1; #1; $display("%b", data_out);
    data_in = 32'd4294967295; #1; $display("%b", data_out);
    data_in = 32'd170; #1; $display("%b", data_out);
    data_in = 32'd2; #1; $display("%b", data_out);
    data_in = 32'd3; #1; $display("%b", data_out);
    data_in = 32'd2147483647; #1; $display("%b", data_out);
    data_in = 32'd4294967210; #1; $display("%b", data_out);
    $finish;
  end
endmodule
