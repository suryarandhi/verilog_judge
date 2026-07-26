module zero_flag_unit(input [7:0] value, output zero);
  // Write your code here
  if value == 0;
  zero =0;
  else
  zero = 1;

endmodule