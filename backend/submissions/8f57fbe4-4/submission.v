module threshold_detector(input [7:0] a, input b,output above_threshold);
  // Write your code here
  assign  b = (a[0] + 2*a[1] + 4*a[2] + 8*a[3] + 16*a[4] + 32*a[5] + 64*a[5] + 128*a[6] + 256*a[7]);
  if (b>100)
  above_threshold <= 1;
  else
  above_threshold <= 0;
endmodule