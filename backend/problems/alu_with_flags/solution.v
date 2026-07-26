module alu_with_flags(input [7:0] a, input [7:0] b, input [2:0] op, output reg [7:0] result, output reg zero, output reg negative, output reg carry);
  reg [8:0] tmp;
  always @(*) begin
    tmp = 9'b0;
    case (op)
      3'b000: begin tmp = a + b; result = tmp[7:0]; carry = tmp[8]; end
      3'b001: begin tmp = {1'b0, a} - {1'b0, b}; result = tmp[7:0]; carry = a < b; end
      3'b010: begin result = a & b; carry = 1'b0; end
      3'b011: begin result = a | b; carry = 1'b0; end
      3'b100: begin result = a ^ b; carry = 1'b0; end
      default: begin result = 8'b0; carry = 1'b0; end
    endcase
    zero = result == 8'b0;
    negative = result[7];
  end
endmodule
