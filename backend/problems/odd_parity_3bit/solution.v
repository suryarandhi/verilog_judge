module odd_parity_3bit(input [2:0] a, output y);
  assign y = ^a;
endmodule
