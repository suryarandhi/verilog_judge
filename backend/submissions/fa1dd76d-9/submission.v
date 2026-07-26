module odd_parity_32bit(input [31:0] a, output y);
  assign y = ^a;
endmodule
