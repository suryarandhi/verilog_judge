module alu_with_flags(input [7:0] a, input [7:0] b, input [2:0] op, output reg [7:0] result, output reg zero, output reg negative, output reg carry);
  always @(*) begin
      result = 8'b0;
      zero = 1'b0;
      negative = 1'b0;
      carry = 1'b0;
    end
endmodule
