module zero_flag_unit(input [7:0] value, output zero);
  assign zero = value == 8'b0;
endmodule
