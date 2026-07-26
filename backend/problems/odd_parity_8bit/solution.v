module odd_parity_8bit(input [7:0] a, output y);
  assign y = ^a;
endmodule
