module shift_left_8bit(input [7:0] a, input [2:0] shamt, output [7:0] y);
  assign y = a << shamt;
endmodule
