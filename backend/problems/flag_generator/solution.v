module flag_generator(input [7:0] result, input carry_in, output zero, output negative, output parity, output carry_out);
  assign zero = result == 8'b0;
  assign negative = result[7];
  assign parity = ~^result;
  assign carry_out = carry_in;
endmodule
