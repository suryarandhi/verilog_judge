module even_parity_4bit(input [3:0] a, output y);
  assign y = ~^a;
endmodule
