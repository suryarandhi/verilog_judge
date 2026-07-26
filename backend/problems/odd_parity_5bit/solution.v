module odd_parity_5bit(input [4:0] a, output y);
  assign y = ^a;
endmodule
