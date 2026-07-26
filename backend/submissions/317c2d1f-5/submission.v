module shift_left_4bit(input [3:0] a, input [1:0] shamt, output [3:0] y);
  assign y = a << shamt;
endmodule
