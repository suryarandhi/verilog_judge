module zero_flag_unit(input [7:0] value, output reg zero);
  // Write your code here
  always@(*) begin
  if(value == 0)
  zero =1;
  else
  zero = 0;
  end
endmodule