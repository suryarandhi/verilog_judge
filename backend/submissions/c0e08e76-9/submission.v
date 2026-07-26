module simple_alu_8bit(input [7:0] a, input [7:0] b, input [2:0] op, output reg [7:0] result, output reg zero);
  always @(*) begin
      result = 8'b0;
      zero = 1'b0;
    end
endmodule
