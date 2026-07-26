module absolute_difference(input [7:0] a, input [7:0] b, output reg [7:0] diff);
  always @(*) begin
    diff = (a >= b) ? (a - b) : (b - a);
  end
endmodule
