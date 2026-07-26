module modulo_unit(input [7:0] a, input [7:0] b, output reg [7:0] remainder);
  always @(*) begin
    remainder = (b == 8'd0) ? 8'd0 : a % b;
  end
endmodule
