module odd_parity_16bit(input [15:0] a, output y);
  assign y = ^a;
endmodule
