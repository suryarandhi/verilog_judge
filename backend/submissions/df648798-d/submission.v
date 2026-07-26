module simple_alu_8(input [7:0] a, input [7:0] b, input [2:0] opcode, output reg [7:0] result, output reg zero, output reg carry);
  reg [8:0] tmp;
  always @(*) begin
    result = 8'b0;
    carry = 1'b0;
    tmp = 9'b0;
    case (opcode)
      3'b000: begin tmp = a + b; result = tmp[7:0]; carry = tmp[8]; end
      3'b001: begin result = a - b; carry = a < b; end
      3'b010: result = a & b;
      3'b011: result = a | b;
      3'b100: result = ~a;
      default: result = 8'b0;
    endcase
    zero = result == 8'b0;
  end
endmodule
