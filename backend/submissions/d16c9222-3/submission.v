module modulo_unit(input [7:0] a, input [7:0] b, output reg [7:0] remainder);
  always @(*) begin
      remainder = 8'b0;
    end
endmodule
