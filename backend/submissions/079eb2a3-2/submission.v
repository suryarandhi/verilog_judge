module even_parity_generator(input [7:0] a, output parity);
  // Write your code here
  assign parity = ~^a;
  

endmodule