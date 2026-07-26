module zero_detector(input [7:0] a,output reg z, output is_zero);
  // Write your code here
  z=(a[0]&a[1]&a[2]&a[3]&a[4]&a[5]&a[6]);
  if z==0:
  is_zero = 0:
  else
  is_zero =1;
endmodule