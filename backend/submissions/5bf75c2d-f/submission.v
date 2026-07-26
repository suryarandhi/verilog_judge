module even_parity_generator(input [7:0] a, output parity);
  // Write your code here
  assign parity = ~(a[0]^a[1]^a[2]^a[3]^a[4]^a[5]^a[6]^a[7]);
  //assign parity = ~^a;(also give same result );

endmodule