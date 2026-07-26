module arithmetic_shift_unit(input signed [15:0] a, input [3:0] shamt, output [15:0] y);
  assign y = a >>> shamt;
endmodule
