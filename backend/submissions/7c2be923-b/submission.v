module detect_msb_one(input [7:0] a, output msb_one);
  if(a[7] == 1)
  msb_one = 1'b1;
  else
  msb_one = 1'b0;
endmodule