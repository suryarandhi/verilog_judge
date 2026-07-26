module simple_alu_8bit(input [7:0] a, input [7:0] b, input [2:0] op, output reg [7:0] result, output reg zero);
  always @(*) begin
    case (op)
      3'b000: result = a + b;
      3'b001: result = a - b;
      3'b010: result = a & b;
      3'b011: result = a | b;
      3'b100: result = ~a;
      default: result = 8'b0;
    endcase
    zero = result == 8'b0;
  end
endmodule
