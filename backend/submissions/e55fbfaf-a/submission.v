module zero_detector(input [7:0] a, output  reg is_zero);
wire z;
  // Write your code here
 assign  z=(a[0] | a[1] | a[2] | a[3] | a[4] | a[5] | a[6]| a[7]);
 always@(*) begin
  if (z==0)
  is_zero = 1;
  else
  is_zero =0;
 end
endmodule