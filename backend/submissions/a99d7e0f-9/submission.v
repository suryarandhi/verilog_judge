module flag_generator(input [7:0] result, input carry_in, output zero, output negative, output parity, output carry_out);
  assign zero = 1'b0;
  assign negative = 1'b0;
  assign parity = 1'b0;
  assign carry_out = 1'b0;
endmodule
