module even_parity_generator(input [7:0] a, output parity);
  assign parity = ~^a;
endmodule
