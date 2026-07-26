module shift_left_16bit(input [15:0] a, input [3:0] shamt, output [15:0] y);
  assign y = a << shamt;
endmodule
